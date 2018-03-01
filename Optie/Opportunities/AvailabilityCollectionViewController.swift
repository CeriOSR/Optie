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
import MapKit
import CoreLocation

private let reuseIdentifier = "Cell"

class AvailabilityCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, UICollectionViewDataSourcePrefetching {

    //put these freaking variables in a struct rey! dont be a moron!
    let popupModels = PopupViewModel()
    var settingsValues = SettingsValues() 
    var locationManager = CLLocationManager()
    var chosenRange: Double = 100000.0
    var timer = Timer()
    var days: [String]?
    var currentUserLocation = CLLocation()
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
    var imageArray = [UIImage?]()
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
//        do {
//            try Auth.auth().signOut()
//        } catch let err {
//            print(err)
//        }
        setupSettingsDefaults()
        setupViews()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        checkIfUserIsLoggedIn()
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SETTINGS"), style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        collectionView?.backgroundColor = self.view.tintColor
        self.collectionView!.register(AvailabilityCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.isScrollEnabled = true
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
    
    @objc func handleSettings() {
        let settingsController = SettingsViewController()
        let navSettings = UINavigationController(rootViewController: settingsController)
        present(navSettings, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {

        self.monday.removeAll()
        self.tuesday.removeAll()
        self.wednesday.removeAll()
        self.thursday.removeAll()
        self.friday.removeAll()
        self.saturday.removeAll()
        self.sunday.removeAll()
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
       fetchUser(uid)
    }
    
    override func viewWillAppear(_ animated: Bool) {

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
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        checkIfUserIsLoggedIn()
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
    
    private func setupSettingsDefaults() {
        let defaults = UserDefaults()
        self.settingsValues.ageValue = defaults.integer(forKey: "ageValue")
        self.settingsValues.gender = defaults.string(forKey: "gender")
        self.settingsValues.bio = defaults.string(forKey: "bio")
        self.settingsValues.distance = defaults.double(forKey: "distance")
        self.settingsValues.skillValue = defaults.integer(forKey: "skillValue")
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentUserLocation = locations[0]
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
            user.address = dictionary["address"] as? String
            user.city = dictionary["city"] as? String
            user.province = dictionary["province"] as? String
            user.imageUrl = dictionary["imageUrl"] as? String
            user.latitude = dictionary["latitude"] as? Double
            user.longitude = dictionary["longitude"] as? Double
            user.age = dictionary["age"] as? String
            user.gender = dictionary["gender"] as? String
            self.user = user
            self.fetchUserProfile(uid)
        }, withCancel: nil)
    }
    
//    func checkIfUserProfileExist(uid: String) {
//        let profileRef = Database.database().reference().child("userProfile").child(uid)
//        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            let dictionary = snapshot.value as? [String: AnyObject]
//            if dictionary != nil {
//                let tabBarController = TabBarController()
//                self.present(tabBarController, animated: true, completion: {
//                })
//            } else {
//                let profileController = ProfileController()
//                let navProfileController = UINavigationController(rootViewController: profileController)
//                self.present(navProfileController, animated: true, completion: nil)
//            }
//        }, withCancel: nil)
//    }
    
    func fetchUserProfile(_ uid: String) {
        let profileRef = Database.database().reference().child("userProfile").child(uid)
        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String: AnyObject]
            if dictionary == nil {
                //go to profileViewController
                let alert = UIAlertController(title: "Please Setup Profile", message: "You must setup your profile to be able to see other users.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    DispatchQueue.main.async {
                        let layout = UICollectionViewFlowLayout()
                        let profileViewController = ProfileViewController(collectionViewLayout: layout)
                        let navProfile = UINavigationController(rootViewController: profileViewController)
                        self.present(navProfile, animated: true, completion: nil)
                        
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
            var skill = SkillLevelModel()
            var availability = AvailabilityModel()
            skill.skillLevel = dictionary?["skillLevel"] as? Int
            skill.skillQ1 = dictionary?["skillQ1"] as? Bool
            skill.skillQ2 = dictionary?["skillQ2"] as? Bool
            skill.skillQ3 = dictionary?["skillQ3"] as? Bool
            skill.skillQ4 = dictionary?["skillQ4"] as? Bool
            skill.skillQ5 = dictionary?["skillQ5"] as? Bool
            
            availability.userType = dictionary?["userType"] as? String
            availability.haveCar = dictionary?["haveCar"] as? Bool
            availability.monday = dictionary?["monday"] as? Bool
            availability.tuesday = dictionary?["tuesday"] as? Bool
            availability.wednesday = dictionary?["wednesday"] as? Bool
            availability.thursday = dictionary?["thursday"] as? Bool
            availability.friday = dictionary?["friday"] as? Bool
            availability.saturday = dictionary?["saturday"] as? Bool
            availability.sunday = dictionary?["sunday"] as? Bool
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
            user.imageUrl = dictionary["imageUrl"] as? String
            user.latitude = dictionary["latitude"] as? Double
            user.longitude = dictionary["longitude"] as? Double
            user.gender = dictionary["gender"] as? String
            user.age = dictionary["age"] as? String
            user.address = dictionary["address"] as? String
            user.city = dictionary["city"] as? String
            user.province = dictionary["province"] as? String
            guard let lat = user.latitude, let long = user.longitude else {return}
            let userLoc = CLLocation(latitude: lat, longitude: long)
            if let distanceSetting = self.settingsValues.distance {
                self.chosenRange = distanceSetting * 1000.0
            }
            if user.uid != Auth.auth().currentUser?.uid {
                let distance = self.currentUserLocation.distance(from: userLoc)
                if distance < self.chosenRange {
                    guard let gender = user.gender else {return}
                    if self.settingsValues.gender == gender || self.settingsValues.gender == "both" {
//                        guard let age = user.age else {return}
//                        guard let ageInt = Int(age) else {return}
//                        guard let ageValue = self.settingsValues.ageValue else {return}
//                        if  ageInt <= Int(ageValue) {
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
                                //handle no users here
                                print("no users available")
                            }
//                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }, withCancel: nil)
    }
    
    func prefetchImages(_ user: OptieUser) {
        var img : UIImage?
        if let urlString = user.imageUrl {
            let url = NSURL(string: urlString)
            URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
                if error != nil {
                    let err = error! as NSError
                    print(err)
                    return
                }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        img = downloadedImage
                        self.imageArray.append(img)
                    }
                }
            }).resume()
        }
    }
}


