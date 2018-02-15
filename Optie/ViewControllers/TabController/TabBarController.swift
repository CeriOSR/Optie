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
        setupNavBar()
        print("TabBar:", self.settingsValues)
        
        let layout1 = UICollectionViewFlowLayout()
        let availableUsersController = AvailabilityCollectionViewController(collectionViewLayout: layout1)
        //        let navAvailableUsersController = UINavigationController(rootViewController: availableUsersController)
        availableUsersController.tabBarItem.title = "Available Users"
        availableUsersController.tabBarItem.image = #imageLiteral(resourceName: "GROUP_DARK")
        
        let profileController = SportsController()
        //        let navProfileController = UINavigationController(rootViewController: profileController)
        profileController.tabBarItem.title = "Profile"
        profileController.tabBarItem.image = #imageLiteral(resourceName: "PROFILE_DARK")
        
        let layout2 = UICollectionViewFlowLayout()
        let messageListController = MessageListController(collectionViewLayout: layout2)
        //        let navMessageListController = UINavigationController(rootViewController: messageListController)
        messageListController.tabBarItem.title = "Chat"
        messageListController.tabBarItem.image = #imageLiteral(resourceName: "MSG_DARK")
        
        viewControllers = [availableUsersController, profileController, messageListController]
        availableUsersController.settingsValues = self.settingsValues
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let availableController = AvailabilityCollectionViewController()
        availableController.settingsValues = self.settingsValues
    }
    
    
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SETTINGS"), style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
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

}
