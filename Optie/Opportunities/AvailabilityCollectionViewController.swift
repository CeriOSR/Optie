//
//  AvailabilityCollectionViewController.swift
//  Optie
//
//  Created by Rey Cerio on 2017-12-17.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

private let reuseIdentifier = "Cell"

class AvailabilityCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var users = [OptieUser]()
    var days: [String]?
//    var availableUsers = [AvailabilableUsersList]()
    var user: OptieUser? {
        didSet{
            navigationItem.title = user?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        collectionView?.backgroundColor = self.view.tintColor
        self.collectionView!.register(AvailabilityCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.isScrollEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let days = self.days else {
            return 0
        }
        
        return days.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AvailabilityCell
        cell.dayLabel.text = self.days?[indexPath.item]
        cell.users = self.users
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 420 /*view.frame.width*/ /*500*/, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, -50)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            let loginController = LoginController()
            self.present(loginController, animated: true, completion: nil)
        } catch let err {
            print("Could not log out", err)
            return
        }
    }
    
    func checkIfUserIsLoggedIn() {
        
        if let uid = Auth.auth().currentUser?.uid {
            fetchUser(uid)
        } else {
            let loginController = LoginController()
            self.present(loginController, animated: true, completion: nil)
        }
        
    }
    
    func fetchUser(_ uid: String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userRef = Database.database().reference().child("user").child(uid)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            var user = OptieUser()
            user.uid = snapshot.key
            user.name = dictionary["name"] as? String
            user.email = dictionary["email"] as? String
            user.fbId = dictionary["fbId"] as? String
            user.location = dictionary["location"] as? String
            user.imageUrl = dictionary["imageUrl"] as? String
            self.user = user
            
            self.fetchUserProfile(uid)
        }, withCancel: nil)
    }
    
    func fetchUserProfile(_ uid: String) {
        let profileRef = Database.database().reference().child("userProfile").child(uid)
        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            var skill = SkillLevelModel()
            var availability = AvailabilityModel()
            skill.skillLevel = dictionary["skillLevel"] as? Int
            skill.skillQ1 = dictionary["skillQ1"] as? Bool
            skill.skillQ2 = dictionary["skillQ2"] as? Bool
            skill.skillQ3 = dictionary["skillQ3"] as? Bool
            skill.skillQ4 = dictionary["skillQ4"] as? Bool
            skill.skillQ5 = dictionary["skillQ5"] as? Bool
            
            availability.userType = dictionary["userType"] as? String
            availability.haveCar = dictionary["haveCar"] as? Bool
            availability.monday = dictionary["monday"] as? Bool
            availability.tuesday = dictionary["tuesday"] as? Bool
            availability.wednesday = dictionary["wednesday"] as? Bool
            availability.thursday = dictionary["thursday"] as? Bool
            availability.friday = dictionary["friday"] as? Bool
            availability.saturday = dictionary["saturday"] as? Bool
            availability.sunday = dictionary["sunday"] as? Bool
            self.getAvailability(availability)
            
        }, withCancel: nil)
    }
    
    func getAvailability(_ availability: AvailabilityModel){
        var availableDays = [String]()
        if availability.monday == true {
            availableDays.append("monday")
        }
        if availability.tuesday == true {
            availableDays.append("tuesday")
        }
        if availability.wednesday == true {
            availableDays.append("wednesday")
        }
        if availability.thursday == true{
            availableDays.append("thursday")
        }
        if availability.friday == true {
            availableDays.append("friday")
        }
        if availability.saturday == true {
            availableDays.append("saturday")
        }
        if availability.sunday == true {
            availableDays.append("sunday")
        }

        self.days = availableDays
        self.fetchAvailableUsers()
//        DispatchQueue.main.async {
//            self.collectionView?.reloadData()
//        }
    }
    
    func fetchAvailableUsers() {
        guard let days = self.days else {return}
        for day in days {
            let ref = Database.database().reference().child("availability").child(day)
            ref.observe(.childAdded, with: { (snap) in
                let key = snap.key
                let userRef = Database.database().reference().child("user").child(key)
                userRef.observeSingleEvent(of: .value, with: { (snapshotUser) in
                    let dictionary = snapshotUser.value as! [String: Any]
                    var user = OptieUser()
                    user.uid = snapshotUser.key
                    user.name = dictionary["name"] as? String
                    user.email = dictionary["email"] as? String
                    user.fbId = dictionary["fbId"] as? String
                    user.location = dictionary["location"] as? String
                    user.imageUrl = dictionary["imageUrl"] as? String

                    
                    self.users.append(user)
                    print(self.users.count)
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                }, withCancel: nil)
            }, withCancel: nil)
        }
    }
}


