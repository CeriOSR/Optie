//
//  RegisterController.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-11.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let popupModel = PopupViewModel()
    
    let containerView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
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
        tf.placeholder = "location"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        view.addSubview(userImage)
        view.addSubview(nameTextField)
        view.addSubview(locationTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)

        view.addConstraintsWithVisualFormat(format: "H:|-140-[v0(100)]", views: userImage)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: nameTextField)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: locationTextField)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: emailTextField)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: passwordTextField)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: registerButton)
        
        view.addConstraintsWithVisualFormat(format: "V:|-100-[v0(100)]-46-[v1(46)]-4-[v2(46)]-4-[v3(46)]-4-[v4(46)]-50-[v5(46)]", views: userImage, nameTextField,locationTextField, emailTextField, passwordTextField, registerButton)
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
        guard let name = nameTextField.text, let location = locationTextField.text, let email = emailTextField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = ["name": name, "location": location, "email": email, "imageUrl": imageUrl]
        let databaseRef = Database.database().reference().child("user").child(uid)
        databaseRef.updateChildValues(values, withCompletionBlock: { (error, reference) in
            if error != nil {
                print("Failed to input to database", error ?? "unknown error")
                return
            }
            let profileController = ProfileController()
            let navProfileController = UINavigationController(rootViewController: profileController)
            self.present(navProfileController, animated: true, completion: nil)
        })
    }
    
    func saveImageToStorage() {
        let imageId = NSUUID().uuidString
        guard let image = userImage.image, let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
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
}
