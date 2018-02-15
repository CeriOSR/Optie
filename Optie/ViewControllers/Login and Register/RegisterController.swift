//
//  RegisterController.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-11.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import Alamofire
import PromiseKit

class RegisterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
//    var user : OptieUser?
    let popupModel = PopupViewModel()
    
    let containerView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        view.layer.masksToBounds = true
        return view
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "name"
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 4
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let locationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "address, city, state, country"
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 4
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "email"
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 4
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 4
        tf.layer.masksToBounds = true
        return tf
    }()
    
    lazy var userImage : UIImageView = {
        let image = UIImageView()
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelector)))
        image.image = UIImage(named: "Logo")
        return image
    }()
    
    lazy var registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = self.view.tintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let genderSegmentControl: UISegmentedControl = {
        let segCon = UISegmentedControl(items: ["male", "female"])
        segCon.tintColor = .white
        segCon.selectedSegmentIndex = 0
        return segCon
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }
    
    func setupViews() {
        view.backgroundColor = self.view.tintColor
        navigationController?.navigationBar.backgroundColor = .clear

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "BACK").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        
        view.addSubview(containerView)

        containerView.anchors(top: view.safeTopAnchor, bottom: view.safeBottomAnchor, left: view.safeLeftAnchor, right: view.safeRightAnchor, paddingTop: 10, paddingBottom: -10, paddingLeft: 10, paddingRight: -10)
        
        containerView.addSubview(userImage)
        containerView.addSubview(nameTextField)
        containerView.addSubview(locationTextField)
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(registerButton)
        containerView.addSubview(genderSegmentControl)

        containerView.addConstraintsWithVisualFormat(format: "H:|-130-[v0(100)]", views: userImage)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: nameTextField)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: locationTextField)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: emailTextField)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: passwordTextField)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: registerButton)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: genderSegmentControl)
        
        containerView.addConstraintsWithVisualFormat(format: "V:|-50-[v0(100)]-46-[v1(40)]-4-[v2(40)]-4-[v3(40)]-4-[v4(40)]-4-[v5(20)]-50-[v6(40)]", views: userImage, nameTextField,locationTextField, emailTextField, passwordTextField, genderSegmentControl, registerButton)
    }
    
    @objc func handleBack() {
        self.present(LoginController(), animated: true, completion: nil)
    }
    
    @objc func handleRegister() {
        if nameTextField.text == nil || locationTextField.text == nil || emailTextField.text == nil || passwordTextField.text == nil {
            self.popupModel.createAlert(title: "One of the fields is empty.", message: "Please fill out all the fields.")
        }
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.popupModel.createAlert(title: "Error", message: "Please try again")
            }
            self.saveImageToStorage()
        }
    }
    
    func saveUserToDB(_ imageUrl: String) {
        guard let name = nameTextField.text, let location = locationTextField.text, let email = emailTextField.text, let gender = genderSegmentControl.titleForSegment(at: genderSegmentControl.selectedSegmentIndex) else {return}
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = ["fbId": "non-fbUser", "name": name, "location": location, "email": email, "imageUrl": imageUrl, "gender": gender]
        let databaseRef = Database.database().reference().child("user").child(uid)
        databaseRef.updateChildValues(values, withCompletionBlock: { (error, reference) in
            if error != nil {
                print("Failed to input to database", error ?? "unknown error")
                return
            }
            var coordinates : CLLocationCoordinate2D?
            let nativeGeocoding = NativeGeocoding(location)
            let geocodingResult = GeocodingResult.init(location)
            nativeGeocoding.geocode().then(execute: { (geocoding) -> Void in
                geocodingResult.native = geocoding
                coordinates = geocoding.coordinates
                if coordinates?.latitude == 0 && coordinates?.longitude == 0 {
                    self.popupModel.createAlert(title: "Address Not Found.", message: "Please enter a valid address.")
                } else {
                    guard let lat = coordinates?.latitude, let long = coordinates?.longitude else {return}
                    databaseRef.updateChildValues(["latitude": lat, "longitude": long])
                }
            })
            let profileController = ProfileController()
            let navProfileController = UINavigationController(rootViewController: profileController)
            self.present(navProfileController, animated: true, completion: nil)
        })
    }
    
    func saveImageToStorage() {
        let imageId = NSUUID().uuidString
        guard let image = userImage.image, let uploadData = UIImageJPEGRepresentation(image, 0.1) else {return}
        let storageRef = Storage.storage().reference().child("profileImage").child(imageId)
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Couldnt not save image to Storage", error ?? "unknown error")
                return
            }
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else {return}
            self.saveUserToDB(imageUrl)
        }
    }
    
    @objc func handleImageSelector() {
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker = UIImage()
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        guard let selectedImage = selectedImageFromPicker as UIImage? else {return}
        print(selectedImage)
            self.userImage.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func convertAddressToCLLocation(location: String) -> CLLocationCoordinate2D {
        var coordinates = CLLocationCoordinate2D()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if error != nil {
                print("GEOCODER: no placemarks found")
            } else {
                let placemark = placemarks
                if let unwrapppedCoords = placemark?.first?.location?.coordinate {
                    coordinates = unwrapppedCoords
                }
            }
        }
        print(coordinates.latitude, coordinates.longitude)
        return coordinates
    }
}



