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
    
    var timer = Timer()
    var days: [String]?
    var monday = [OptieUser]()
    var sunday = [OptieUser]()
    var saturday = [OptieUser]()
    var friday = [OptieUser]()
    var thursday = [OptieUser]()
    var wednesday = [OptieUser]()
    var tuesday = [OptieUser]()
    var mondayUsers = UsersDayList()
    var tuesdayUsers = UsersDayList()
    var wednesdayUsers = UsersDayList()
    var thursdayUsers = UsersDayList()
    var fridayUsers = UsersDayList()
    var saturdayUsers = UsersDayList()
    var sundayUsers = UsersDayList()
    var daysArray = [Array<Any>]()
    var availableUsers = UsersDayList()
    var availableUsersArray = [UsersDayList]()
    var availability = AvailabilityModel()
    var skill = SkillLevelModel()
    var user: OptieUser? {
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    let settingsPopupView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray /*UIColor(r: 13, g: 31, b: 61)*/
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SETTINGS"), style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        collectionView?.backgroundColor = self.view.tintColor
        self.collectionView!.register(AvailabilityCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.isScrollEnabled = true
        view.addSubview(settingsPopupView)
        settingsPopupView.centerXAnchor.constraintEqualToSystemSpacingAfter(view.centerXAnchor, multiplier: 0).isActive = true
        settingsPopupView.centerYAnchor.constraintEqualToSystemSpacingBelow(view.centerYAnchor, multiplier: 0).isActive = true
        settingsPopupView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        settingsPopupView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.monday.removeAll()
        self.tuesday.removeAll()
        self.wednesday.removeAll()
        self.thursday.removeAll()
        self.friday.removeAll()
        self.saturday.removeAll()
        self.sunday.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        let label = self.days![indexPath.item]
        cell.dayLabel.text = label
        switch label {
        case "Monday":
            cell.users = self.monday
        case "Tuesday":
            cell.users = self.tuesday
        case "Wednesday":
            cell.users = self.wednesday
        case "Thursday":
            cell.users = self.thursday
        case "Friday":
            cell.users = self.friday
        case "Saturday":
            cell.users = self.saturday
        case "Sunday":
            cell.users = self.sunday
        default:
            cell.users = []
        }
        cell.availabilityController = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 420, height: 176)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, -50)
    }
    
    func showChosenUserController(user: OptieUser) {
        let chosenProfileController = ChosenUserProfileController()
        chosenProfileController.availability = self.availability
        chosenProfileController.chosenUser = user
        chosenProfileController.skill = self.skill
        navigationController?.pushViewController(chosenProfileController, animated: true)
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
            self.skill = skill
            self.availability = availability
            self.getAvailability(availability)
            
        }, withCancel: nil)
    }
    
    func getAvailability(_ availability: AvailabilityModel){
        var availableDays = [String]()
        if availability.monday == true {
            availableDays.append("Monday")
        }
        if availability.tuesday == true {
            availableDays.append("Tuesday")
        }
        if availability.wednesday == true {
            availableDays.append("Wednesday")
        }
        if availability.thursday == true{
            availableDays.append("Thursday")
        }
        if availability.friday == true {
            availableDays.append("Friday")
        }
        if availability.saturday == true {
            availableDays.append("Saturday")
        }
        if availability.sunday == true {
            availableDays.append("Sunday")
        }
        self.days = availableDays
        for day in availableDays {
            self.fetchUsers(day)
        }
    }
    
    func fetchUsers(_ day: String) {
        let ref = Database.database().reference().child("availability").child(day)
        ref.observe(.childAdded, with: { (snap) in
            let key = snap.key
            let valueDay = snap.value as! String
            self.fetchSingleUser(key, valueDay: valueDay)
            
        }, withCancel: nil)
    }
    
    func fetchSingleUser(_ key: String, valueDay: String){
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
            if user.uid != Auth.auth().currentUser?.uid {
                switch valueDay {
                case "Monday":
                    self.monday.append(user)
                    self.mondayUsers.day = "Monday"
                    self.mondayUsers.users = self.monday
                    self.availableUsersArray.append(self.mondayUsers)
                case "Tuesday":
                    self.tuesday.append(user)
                    self.tuesdayUsers.day = "Tuesday"
                    self.tuesdayUsers.users = self.tuesday
                    self.availableUsersArray.append(self.tuesdayUsers)
                case "Wednesday":
                    self.wednesday.append(user)
                    self.wednesdayUsers.day = "Wednesday"
                    self.wednesdayUsers.users = self.wednesday
                    self.availableUsersArray.append(self.wednesdayUsers)
                case "Thursday":
                    self.thursday.append(user)
                    self.thursdayUsers.day = "Thursday"
                    self.thursdayUsers.users = self.thursday
                    self.availableUsersArray.append(self.thursdayUsers)
                case "Friday":
                    self.friday.append(user)
                    self.fridayUsers.day = "Friday"
                    self.fridayUsers.users = self.friday
                    self.availableUsersArray.append(self.fridayUsers)
                case "Saturday":
                    self.saturday.append(user)
                    self.saturdayUsers.day = "Saturday"
                    self.saturdayUsers.users = self.saturday
                    self.availableUsersArray.append(self.saturdayUsers)
                case "Sunday":
                    self.sunday.append(user)
                    self.sundayUsers.day = "Sunday"
                    self.sundayUsers.users = self.sunday
                    self.availableUsersArray.append(self.sundayUsers)
                default:
                    print("No available users")
                }
            }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
        }, withCancel: nil)
    }
   
    @objc func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    @objc func handleSettings() {
        print("settings ")
    }
}


