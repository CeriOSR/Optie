//
//  ProfileViewController.swift
//  Optie
//
//  Created by Rey Cerio on 2018-02-19.
//  Copyright © 2018 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellid = "cellId"
    var skill : SkillLevelModel?
    var availability : AvailabilityModel?
    var user: OptieUser? {
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView?.register(ProfileCell.self, forCellWithReuseIdentifier: cellid)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(handleSubmit))
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ProfileCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 1250)
    }
    
    @objc func handleSubmit(cell: ProfileCell) {
        saveProfileToDatabase()
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
    
    func setSkillModel(cell: ProfileCell) -> SkillLevelModel {
        var skillLevel = SkillLevelModel()
        
        if cell.typeSwitch1.isEnabled == true {
            skillLevel.skillQ1 = true
        } else {
            skillLevel.skillQ1 = false
        }
        if cell.typeSwitch2.isOn == true {
            skillLevel.skillQ2 = true
        } else {
            skillLevel.skillQ2 = false
        }
        if cell.typeSwitch3.isOn == true {
            skillLevel.skillQ3 = true
        } else {
            skillLevel.skillQ3 = false
        }
        if cell.typeSwitch4.isOn == true {
            skillLevel.skillQ4 = true
        } else {
            skillLevel.skillQ4 = false
        }
        if cell.typeSwitch5.isOn == true {
            skillLevel.skillQ5 = true
        } else {
            skillLevel.skillQ5 = false
        }
        return skillLevel
    }
    
    func setAvailabilityModel(cell: ProfileCell) -> AvailabilityModel {
        var availability = AvailabilityModel()
        availability.userType = cell.sportsSegmentControl.titleForSegment(at: cell.sportsSegmentControl.selectedSegmentIndex)
        if cell.carSegmentControl.selectedSegmentIndex == 0 {
            availability.haveCar = true
        } else {
            availability.haveCar = false
        }
        if cell.mondaySwitch.isOn == true {
            availability.monday = true
        } else {
            availability.monday = false
        }
        if cell.tuesdaySwitch.isOn == true {
            availability.tuesday = true
        } else {
            availability.tuesday = false
        }
        if cell.wednesdaySwitch.isOn == true {
            availability.wednesday = true
        } else {
            availability.wednesday = false
        }
        if cell.thursdaySwitch.isOn == true {
            availability.thursday = true
        } else {
            availability.thursday = false
        }
        if cell.fridaySwitch.isOn == true {
            availability.friday = true
        } else {
            availability.friday = false
        }
        if cell.saturdaySwitch.isOn == true {
            availability.saturday = true
        } else {
            availability.saturday = false
        }
        if cell.sundaySwitch.isOn == true {
            availability.sunday = true
        } else {
            availability.sunday = false
        }
        
        return availability
    }
    
    func saveProfileToDatabase(){
        let cell = ProfileCell()
        let skillLevel = setSkillModel(cell: cell)
        let availability = setAvailabilityModel(cell: cell)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [
            "bio": cell.bioTextView.text,
            "skillLevel": roundf(cell.skillLevelSlider.value),
            "skillQ1": skillLevel.skillQ1 as Any,
            "skillQ2": skillLevel.skillQ2 as Any,
            "skillQ3": skillLevel.skillQ3 as Any,
            "skillQ4": skillLevel.skillQ4 as Any,
            "skillQ5": skillLevel.skillQ5 as Any,
            "userType": availability.userType as Any,
            "haveCar": availability.haveCar as Any,
            "monday": availability.monday as Any,
            "tuesday": availability.tuesday as Any,
            "wednesday": availability.wednesday as Any,
            "thursday": availability.thursday as Any,
            "friday": availability.friday as Any,
            "saturday": availability.saturday as Any,
            "sunday" : availability.sunday as Any
            ] as [String: Any]
        let profileRef = Database.database().reference().child("userProfile").child(uid)
        profileRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print("Could not save profile", error ?? "unknown error")
                return
            }
            let availabilityRef = Database.database().reference().child("availability")
            if availability.monday == true {
                availabilityRef.child("Monday").updateChildValues([uid:"Monday"])
            }
            if availability.tuesday == true {
                availabilityRef.child("Tuesday").updateChildValues([uid:"Tuesday"])
            }
            if availability.wednesday == true {
                availabilityRef.child("Wednesday").updateChildValues([uid:"Wednesday"])
            }
            if availability.thursday == true {
                availabilityRef.child("Thursday").updateChildValues([uid:"Thursday"])
            }
            if availability.friday == true {
                availabilityRef.child("Friday").updateChildValues([uid:"Friday"])
            }
            if availability.saturday == true {
                availabilityRef.child("Saturday").updateChildValues([uid:"Saturday"])
            }
            if availability.sunday == true {
                availabilityRef.child("Sunday").updateChildValues([uid:"Sunday"])
            }
            let tabBarController = TabBarController()
            self.present(tabBarController, animated: true, completion: {
                print("Success")
            })
        }
    }
}


