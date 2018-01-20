//
//  ChosenUserProfile.swift
//  Optie
//
//  Created by Rey Cerio on 2018-01-10.
//  Copyright © 2018 Rey Cerio. All rights reserved.
//

import UIKit

class ChosenUserProfileController: UIViewController {
    
    var availability: AvailabilityModel? {
        didSet{
            print(String(describing: availability?.haveCar))
        }
    }
    var skill: SkillLevelModel? {
        didSet{
            print(String(describing: skill?.skillLevel))
        }
    }
    var chosenUser: OptieUser? {
        didSet{
            navigationItem.title = chosenUser?.name
            print(chosenUser?.name)
        }
    }
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        return cv
    }()
    
    lazy var chatButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = self.view.tintColor
        button.setTitleColor(self.view.tintColor, for: .normal)
        button.setImage(#imageLiteral(resourceName: "SEND").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.setTitle("Invite to Chat", for: .normal)
        button.addTarget(self, action: #selector(handleChat), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        view.backgroundColor = self.view.tintColor
        view.addSubview(containerView)
        containerView.anchors(top: view.safeTopAnchor, bottom: view.safeBottomAnchor, left: view.safeLeftAnchor, right: view.safeRightAnchor, paddingTop: 10, paddingBottom: -10, paddingLeft: 10, paddingRight: -10)
        
        containerView.addSubview(chatButton)
//        chatButton.anchors(top: containerView.centerYAnchor, bottom: nil, left: containerView.centerXAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 150, height: 50)
        containerView.addConstraintsWithVisualFormat(format: "H:|-100-[v0(100)]", views: chatButton)
        containerView.addConstraintsWithVisualFormat(format: "V:|-350-[v0(50)]", views: chatButton)
        
    }
    
    @objc func handleBack() {
        let tabBar = TabBarController()
        present(tabBar, animated: true) {
            
        }
    }
    
    @objc func handleChat() {
        let layout = UICollectionViewFlowLayout()
        let newMessageController = NewMessagesCollectionViewController(collectionViewLayout: layout)
        let navNewMessageController = UINavigationController(rootViewController: newMessageController)
        present(navNewMessageController, animated: true) {
            newMessageController.chosenUser = self.chosenUser
        }
    }
    
}
