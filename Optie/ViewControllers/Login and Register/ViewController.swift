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
    
    var fbMember = FbUser()
    let popUpViewModel = PopupViewModel()
    
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
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logoImage)
        view.addSubview(appNameImage)
        view.addSubview(loginButton)
        view.addSubview(fBLoginButton)
        view.addSubview(createAccountButton)
        
        
        view.addConstraintsWithVisualFormat(format: "H:|-140-[v0(100)]", views: logoImage)
        view.addConstraintsWithVisualFormat(format: "H:|-140-[v0(100)]", views: appNameImage)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: emailTextField)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: passwordTextField)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: loginButton)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: fBLoginButton)
        view.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: createAccountButton)

        view.addConstraintsWithVisualFormat(format: "V:|-100-[v0(100)]-4-[v1(50)]-46-[v2(46)]-4-[v3(46)]-50-[v4(46)]-10-[v5(46)]-10-[v6(46)]", views: logoImage, appNameImage, emailTextField, passwordTextField, loginButton, fBLoginButton, createAccountButton)

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
            self.fbMember.imageUrl = imageURL
            self.fbMember.fbEmail = fbUser["email"] as? String
            self.fbMember.fbId = fbUser["id"] as? String
            self.fbMember.fbName = fbUser["name"] as? String
            print(imageURL)
            let user = ["email": self.fbMember.fbEmail, "id": self.fbMember.fbId, "name": self.fbMember.fbName, "imageUrl": self.fbMember.imageUrl]
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
            let profileController = ProfileController()
            let navProfileController = UINavigationController(rootViewController: profileController)
            self.present(navProfileController, animated: true, completion: nil)
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
            let profileController = ProfileController()
            let navProfileController = UINavigationController(rootViewController: profileController)
            self.present(navProfileController, animated: true, completion: nil)
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

}

