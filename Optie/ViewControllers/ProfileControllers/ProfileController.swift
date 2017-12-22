//
//  ProfileController.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-12.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileController: UIViewController {
    
    let setupViews = SetupViews()
    var user = OptieUser()
    var fbUser : FbUser? {
        didSet{
            nameLabel.text = fbUser?.fbName
            guard let imageUrl = fbUser?.imageUrl else {return}
            self.userImage.loadEventImageUsingCacheWithUrlString(urlString: imageUrl)
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        view.layer.masksToBounds = true
        return view
    }()
    
    let heyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Hey,"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    let userImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 75
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.image = UIImage(named: "Logo")
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Elizabeth Jo Cerio"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let directionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Please take a moment to setup your profile."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var proceedButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next >", for: .normal)
        button.backgroundColor = self.view.tintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(presentSportsController), for: .touchUpInside)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViewsProfileController()
//        if let name = self.fbUser?.fbName ?? self.user.name
        
        self.nameLabel.text = self.fbUser?.fbName
        if let imageUrl = self.fbUser?.imageUrl {
            self.userImage.loadEventImageUsingCacheWithUrlString(urlString: imageUrl)
        } else {
            guard let imageUrl = self.user.imageUrl else {return}
            self.userImage.loadEventImageUsingCacheWithUrlString(urlString: imageUrl)
        }
    }
    
    func setupViewsProfileController() {
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        
//        let height = view.frame.height - 75
//        let y = view.frame.height - height
//        containerView.frame = CGRect(x: 8, y: y, width: view.frame.width - 16, height: height)
        
        view.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: containerView)
        view.addConstraintsWithVisualFormat(format: "V:|-100-[v0]-20-|", views: containerView)
        
        containerView.addSubview(heyLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(userImage)
        containerView.addSubview(directionLabel)
        containerView.addSubview(proceedButton)
        
        containerView.addConstraintsWithVisualFormat(format: "H:|-120-[v0(100)]", views: heyLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: nameLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-100-[v0(150)]", views: userImage)
        containerView.addConstraintsWithVisualFormat(format: "H:|-80-[v0(200)]", views: directionLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:[v0(100)]-10-|", views: proceedButton)
        
        containerView.addConstraintsWithVisualFormat(format: "V:|-75-[v0(50)]-4-[v1(50)]-10-[v2(150)]-8-[v3(150)]", views: heyLabel, nameLabel, userImage, directionLabel)
        containerView.addConstraintsWithVisualFormat(format: "V:[v0(45)]-10-|", views: proceedButton)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            let loginController = LoginController()
            self.present(loginController, animated: true, completion: nil)
        } catch {
            print("unable to signout", error)
        }
    }
    
    @objc func presentSportsController() {
        let sportsController = SportsController()
        let navSportsController = UINavigationController(rootViewController: sportsController)
        self.present(navSportsController, animated: true) {
            sportsController.user = self.user
        }
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userRef = Database.database().reference().child("user").child(uid)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            self.user.uid = snapshot.key
            self.user.name = dictionary["name"] as? String
            self.user.email = dictionary["email"] as? String
            self.user.location = dictionary["location"] as? String
            self.user.imageUrl = dictionary["imageUrl"] as? String
            
        }, withCancel: nil)
    }
    
}
