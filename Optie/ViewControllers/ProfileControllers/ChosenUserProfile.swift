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
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) //lets make this containerView color the standard
        view.layer.masksToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Gorjeous Randy Flamethrower"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = "Vancouver, BC"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let userImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.image = UIImage(named: "PROFILE_DARK")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let carImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isHidden = true
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.image = UIImage(named: "CAR_SMALL")?.withRenderingMode(.alwaysOriginal)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let skillLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genderAgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = true
        tv.allowsEditingTextAttributes = false
        tv.isEditable = false
        tv.allowsEditingTextAttributes = false
        tv.text = "Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower Gorjeous Randy Flamethrower "
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()    
    
    lazy var chatButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = self.view.tintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
//        button.setImage(#imageLiteral(resourceName: "SEND").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Invite to Chat", for: .normal)
        button.addTarget(self, action: #selector(handleChat), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleOccupyFields()
        setupViews()
    }
    
    func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        view.backgroundColor = self.view.tintColor
        view.addSubview(containerView)
        containerView.anchors(top: view.safeTopAnchor, bottom: view.safeBottomAnchor, left: view.safeLeftAnchor, right: view.safeRightAnchor, paddingTop: 10, paddingBottom: -10, paddingLeft: 10, paddingRight: -10)
        
        containerView.addSubview(chatButton)
        containerView.addSubview(nameLabel)
        containerView.addSubview(locationLabel)
        containerView.addSubview(skillLabel)
        containerView.addSubview(genderAgeLabel)
        containerView.addSubview(bioTextView)
        containerView.addSubview(userImage)
        containerView.addSubview(carImageView)
        
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        userImage.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        userImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        carImageView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 50).isActive = true
        carImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 70).isActive = true
        carImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        carImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        skillLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 50).isActive = true
        skillLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -70).isActive = true
        skillLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        skillLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        genderAgeLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 10).isActive = true
        genderAgeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        genderAgeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        genderAgeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        bioTextView.topAnchor.constraint(equalTo: genderAgeLabel.bottomAnchor, constant: 20).isActive = true
        bioTextView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        bioTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bioTextView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9).isActive = true
        
        chatButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20).isActive = true
        chatButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        chatButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        chatButton.widthAnchor.constraint(equalTo: userImage.widthAnchor, multiplier: 2).isActive = true
    }
    
    private func handleOccupyFields() {
        guard let city = chosenUser?.city, let province = chosenUser?.province, let name = chosenUser?.name else {return}
        guard let skill = skill?.skillLevel else {return}
        guard let gender = chosenUser?.gender, let age = chosenUser?.age else {return}
        nameLabel.text = name
        locationLabel.text = "\(String(describing: city))" + ", " + "\(String(describing: province))"
        skillLabel.text = "\(String(describing: skill))"
        if let imageUrl = chosenUser?.imageUrl {
            userImage.loadEventImageUsingCacheWithUrlString(urlString: imageUrl)
        }
        if availability?.haveCar == true {
            carImageView.isHidden = false
            carImageView.image = UIImage(named: "CAR_SMALL")?.withRenderingMode(.alwaysOriginal)
        } else {
            carImageView.isHidden = true
        }
        genderAgeLabel.text = "\(String(describing: gender.first))" + ", " + "\(String(describing: age))"
        
        //also save the bio to firebase
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
