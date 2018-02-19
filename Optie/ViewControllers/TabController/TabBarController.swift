//
//  TabControllerViewController.swift
//  Optie
//
//  Created by Rey Cerio on 2018-01-03.
//  Copyright © 2018 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class TabBarController: UITabBarController {

    var settingsValues = SettingsValues(){
        didSet{
            print(self.settingsValues)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout1 = UICollectionViewFlowLayout()
        let availableUsersController = AvailabilityCollectionViewController(collectionViewLayout: layout1)
        let navAvailableUsersController = UINavigationController(rootViewController: availableUsersController)
        availableUsersController.tabBarItem.title = "Available Users"
        availableUsersController.tabBarItem.image = #imageLiteral(resourceName: "GROUP_DARK")
        
        let profileController = SportsController()
//        let navProfileController = UINavigationController(rootViewController: profileController)
        profileController.tabBarItem.title = "Profile"
        profileController.tabBarItem.image = #imageLiteral(resourceName: "PROFILE_DARK")
        
        let layout2 = UICollectionViewFlowLayout()
        let messageListController = MessageListController(collectionViewLayout: layout2)
        let navMessageListController = UINavigationController(rootViewController: messageListController)
        messageListController.tabBarItem.title = "Chat"
        messageListController.tabBarItem.image = #imageLiteral(resourceName: "MSG_DARK")
        
        viewControllers = [navAvailableUsersController, profileController, navMessageListController]
        availableUsersController.settingsValues = self.settingsValues
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults()
        self.settingsValues.ageValue = defaults.integer(forKey: "ageValue")
        self.settingsValues.gender = defaults.string(forKey: "gender")
        self.settingsValues.bio = defaults.string(forKey: "bio")
        self.settingsValues.distance = defaults.double(forKey: "distance")
        self.settingsValues.skillValue = defaults.integer(forKey: "skillValue")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let availableController = AvailabilityCollectionViewController()
        availableController.settingsValues = self.settingsValues
    }
}
