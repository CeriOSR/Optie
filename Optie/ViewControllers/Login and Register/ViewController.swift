//
//  ViewController.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-05.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    var user = OptieUser()
//    var fbMember = FbUser()
    let popUpViewModel = PopupViewModel()
    
    let containerView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        view.layer.masksToBounds = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
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
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 4
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let logoImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo")
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        return image
    }()
    
    let appNameImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo")
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = self.view.tintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(loginWithEmailAndPassword), for: .touchUpInside)
        return button
    }()
    
    lazy var fBLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.delegate = self
        button.readPermissions = ["email", "public_profile"]
        return button
    }()
    
    lazy var createAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Or create a new account", for: .normal)
        button.setTitleColor(self.view.tintColor, for: .normal)
        button.addTarget(self, action: #selector(self.presentRegisterController), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        
        view.backgroundColor = self.view.tintColor
        view.addSubview(containerView)
        
        view.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: containerView)
        view.addConstraintsWithVisualFormat(format: "V:|-100-[v0]-20-|", views: containerView)

//        if #available(iOS 11, *) {
//            let guide = view.safeAreaLayoutGuide
//            NSLayoutConstraint.activate([
//                containerView.topAnchor.constraint(equalTo: guide.topAnchor)
//                ])
//        } else {
//            NSLayoutConstraint.activate([
//                containerView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
//                ])
//        }
//        NSLayoutConstraint.activate([
////            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
////            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            containerView.heightAnchor.constraint(equalToConstant: 65)
//            ])
        
        containerView.anchors(top: view.safeTopAnchor, bottom: view.safeBottomAnchor, left: view.safeLeftAnchor, right: view.safeRightAnchor, paddingTop: 10, paddingBottom: -10, paddingLeft: 10, paddingRight: -10)
        
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(logoImage)
        containerView.addSubview(appNameImage)
        containerView.addSubview(loginButton)
        containerView.addSubview(fBLoginButton)
        containerView.addSubview(createAccountButton)
        
        
        containerView.addConstraintsWithVisualFormat(format: "H:|-130-[v0(100)]", views: logoImage)
        containerView.addConstraintsWithVisualFormat(format: "H:|-130-[v0(100)]", views: appNameImage)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: emailTextField)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: passwordTextField)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: loginButton)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: fBLoginButton)
        containerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: createAccountButton)

        view.addConstraintsWithVisualFormat(format: "V:|-50-[v0(100)]-4-[v1(50)]-46-[v2(46)]-4-[v3(46)]-45-[v4(46)]-10-[v5(46)]-10-[v6(46)]", views: logoImage, appNameImage, emailTextField, passwordTextField, loginButton, fBLoginButton, createAccountButton)

    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        print("Successfully logged in with facebook!!!")
        self.loginUserToFirebase()
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did logout of facebook!!!")
    }
    
    func loginUserToFirebase() {
        guard let accessToken = FBSDKAccessToken.current() else {return}
        guard let tokenString = accessToken.tokenString else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("Could not log in", error ?? "error not found")
            }
            self.fbGraphrequest()
        }
    }
    
    func fbGraphrequest() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.type(normal)"]).start { (connection, result, error) in
            if  error != nil {
                print("Failed graphRequest", error!)
                return
            }
            let fbUser = result as! [String: Any]
            guard let imageURL = ((fbUser["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String else {return}
            self.user.imageUrl = imageURL
            self.user.email = fbUser["email"] as? String
            self.user.fbId = fbUser["id"] as? String
            self.user.name = fbUser["name"] as? String
            self.user.location = "Location to be determined"
            print(imageURL)
            let user = ["email": self.user.email, "fbid": self.user.fbId, "name": self.user.name, "location": self.user.location, "imageUrl": self.user.imageUrl]
            self.saveUserToDatabase(user: user as! [String : String])
        }
    }
    
    func saveUserToDatabase(user: [String: String]) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference().child("user").child(uid)
        databaseRef.updateChildValues(user) { (error, reference) in
            if error != nil {
                print("Could not save user to firebase", error!)
            }
            self.checkIfUserProfileExist(uid: uid)
        }
    }
    
    @objc func loginWithEmailAndPassword() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.popUpViewModel.createAlert(title: "Invalid email or password", message: "Email and password does not match")
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else {return}
            self.checkIfUserProfileExist(uid: uid)
        }
    }
    
    @objc func presentRegisterController() {
        let registerController = RegisterController()
        let navRegisterController = UINavigationController(rootViewController: registerController)
        self.present(navRegisterController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkIfUserProfileExist(uid: String) {
        let profileRef = Database.database().reference().child("userProfile").child(uid)
        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            if dictionary != nil {
//                let layout = UICollectionViewFlowLayout()
//                let availabilityCollectionView = AvailabilityCollectionViewController(collectionViewLayout: layout)
//                let navAvailabilityCollectionView = UINavigationController(rootViewController: availabilityCollectionView)
//                self.present(navAvailabilityCollectionView, animated: true, completion: nil)
                //possibly fetch profile info and pass data to collectionView
                let tabBarController = TabBarController()
                self.present(tabBarController, animated: true, completion: {
                    print("Success")
                })
            } else {
                let profileController = ProfileController()
                let navProfileController = UINavigationController(rootViewController: profileController)
                self.present(navProfileController, animated: true, completion: nil)

            }
        }, withCancel: nil)
    }


    
//    func handleTypeOfUser() {
//        if let providerId = Auth.auth().currentUser?.providerID {
//            if providerId == "facebook.com" {
//
//            }
//        }
//    }
    
}

