//
//  SkillLevelController.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-12.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase

class SkillLevelController: UIViewController {
    
    var user = OptieUser()
    var availability : AvailabilityModel? {
        didSet{
            navigationItem.title = self.availability?.userType
            if self.availability?.userType == "Snowboard" {
                skillLevelImageView.image = UIImage(named: "Snowboard 1")
            } else {
                skillLevelImageView.image = UIImage(named: "Ski 1")
            }
        }
    }
    var skillLevel = SkillLevelModel()
    
    let skillContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.masksToBounds = true
        return view
    }()
    
    let skillLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "SKILL LEVEL:"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let skillLevelImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        return image
    }()
    
    lazy var skillLevelSlider: UISlider = {
        let slider = UISlider()
        slider.isUserInteractionEnabled = true
        slider.value = 1
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.addTarget(self, action: #selector(changeSliderValue), for: .valueChanged)
        return slider
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "WHAT TYPE ARE YOU?:"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let typeLabel1: UILabel = {
        let label = UILabel()
        label.text = "I like to stop for hot chocolate."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let typeLabel2: UILabel = {
        let label = UILabel()
        label.text = "I pack a lunch and eat on the chair."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let typeLabel3: UILabel = {
        let label = UILabel()
        label.text = "I like to ride park."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let typeLabel4: UILabel = {
        let label = UILabel()
        label.text = "I'm interested in off piste."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let typeLabel5: UILabel = {
        let label = UILabel()
        label.text = "I would skip work for good snow."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let typeSwitch1: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    
    let typeSwitch2: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    
    let typeSwitch3: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    
    let typeSwitch4: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    
    let typeSwitch5: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    
    lazy var submitButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = self.view.tintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViews()
    }
    
    @objc func changeSliderValue() {
        skillLevelSlider.value = roundf(self.skillLevelSlider.value)
        let skill = round(skillLevelSlider.value)
        if self.availability?.userType == "Snowboard" {
            switch skill {
            case 1 :
                skillLevelImageView.image = UIImage(named: "Snowboard 1")
            case 2 :
                skillLevelImageView.image = UIImage(named: "Snowboard 2")
            case 3 :
                skillLevelImageView.image = UIImage(named: "Snowboard 3")
            case 4 :
                skillLevelImageView.image = UIImage(named: "Snowboard 4")
            case 5 :
                skillLevelImageView.image = UIImage(named: "Snowboard 5")
            default:
                skillLevelImageView.image = UIImage(named: "Snowboard 1")

            }
        } else if self.availability?.userType == "Ski" || self.availability?.userType == "Both"{
            switch skill {
            case 1 :
                skillLevelImageView.image = UIImage(named: "Ski 1")
            case 2 :
                skillLevelImageView.image = UIImage(named: "Ski 2")
            case 3 :
                skillLevelImageView.image = UIImage(named: "Ski 3")
            case 4 :
                skillLevelImageView.image = UIImage(named: "Ski 4")
            case 5 :
                skillLevelImageView.image = UIImage(named: "Ski 5")
            default:
                skillLevelImageView.image = UIImage(named: "Ski 1")

            }
        }
        
    }
    
    @objc func handleBack() {
        let sportsController = SportsController()
        let navSportsController = UINavigationController(rootViewController: sportsController)
        self.present(navSportsController, animated: true, completion: nil)
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        view.addSubview(skillContainerView)
        let height = view.frame.height - 75
        let y = view.frame.height - height
        
        skillContainerView.frame = CGRect(x: 8, y: y, width: view.frame.width - 16, height: height)
        
        skillContainerView.addSubview(skillLevelLabel)
        skillContainerView.addSubview(skillLevelImageView)
        skillContainerView.addSubview(skillLevelSlider)
        skillContainerView.addSubview(typeLabel)
        skillContainerView.addSubview(typeLabel1)
        skillContainerView.addSubview(typeSwitch1)
        skillContainerView.addSubview(typeLabel2)
        skillContainerView.addSubview(typeSwitch2)
        skillContainerView.addSubview(typeLabel3)
        skillContainerView.addSubview(typeSwitch3)
        skillContainerView.addSubview(typeLabel4)
        skillContainerView.addSubview(typeSwitch4)
        skillContainerView.addSubview(typeLabel5)
        skillContainerView.addSubview(typeSwitch5)
        skillContainerView.addSubview(submitButton)
        
        //HORIZONTAL
        
        skillContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: skillLevelLabel)
        skillContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: skillLevelImageView)
        skillContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: skillLevelSlider)
        skillContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: typeLabel)
        skillContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-4-[v1]-10-|", views: typeLabel1, typeSwitch1)
        skillContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-4-[v1]-10-|", views: typeLabel2, typeSwitch2)
        skillContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-4-[v1]-10-|", views: typeLabel3, typeSwitch3)
        skillContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-4-[v1]-10-|", views: typeLabel4, typeSwitch4)
        skillContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-4-[v1]-10-|", views: typeLabel5, typeSwitch5)
        skillContainerView.addConstraintsWithVisualFormat(format: "H:[v0(100)]-10-|", views: submitButton)

        //VERTICAL
        
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-10-[v0(20)]-6-[v1(180)]-20-[v2(20)]-20-[v3(20)]", views: skillLevelLabel, skillLevelImageView, skillLevelSlider, typeLabel)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-304-[v0(20)]", views: typeLabel1)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-300-[v0]", views: typeSwitch1)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-344-[v0(20)]", views: typeLabel2)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-340-[v0]", views: typeSwitch2)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-384-[v0(20)]", views: typeLabel3)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-380-[v0]", views: typeSwitch3)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-424-[v0(20)]", views: typeLabel4)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-420-[v0]", views: typeSwitch4)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-464-[v0(20)]", views: typeLabel5)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:|-460-[v0]", views: typeSwitch5)
        skillContainerView.addConstraintsWithVisualFormat(format: "V:[v0(45)]-10-|", views: submitButton)
    }
    
    func userSkillLevel() -> SkillLevelModel {
        var skillLevel = SkillLevelModel()
        
        if typeSwitch1.isEnabled == true {
            skillLevel.skillQ1 = true
        } else {
            skillLevel.skillQ1 = false
        }
        if typeSwitch2.isOn == true {
            skillLevel.skillQ2 = true
        } else {
            skillLevel.skillQ2 = false
        }
        if typeSwitch3.isOn == true {
            skillLevel.skillQ3 = true
        } else {
            skillLevel.skillQ3 = false
        }
        if typeSwitch4.isOn == true {
            skillLevel.skillQ4 = true
        } else {
            skillLevel.skillQ4 = false
        }
        if typeSwitch5.isOn == true {
            skillLevel.skillQ5 = true
        } else {
            skillLevel.skillQ5 = false
        }
        return skillLevel
    }
    @objc func handleSubmit() {
        saveProfileToDatabase()
    }
    func saveProfileToDatabase(){
        let skillLevel = userSkillLevel()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [
            "skillLevel": roundf(skillLevelSlider.value),
            "skillQ1": skillLevel.skillQ1 as Any,
            "skillQ2": skillLevel.skillQ2 as Any,
            "skillQ3": skillLevel.skillQ3 as Any,
            "skillQ4": skillLevel.skillQ4 as Any,
            "skillQ5": skillLevel.skillQ5 as Any,
            "userType": self.availability?.userType as Any,
            "haveCar": self.availability?.haveCar as Any,
            "monday": self.availability?.monday as Any,
            "tuesday": self.availability?.tuesday as Any,
            "wednesday": self.availability?.wednesday as Any,
            "thursday": self.availability?.thursday as Any,
            "friday": self.availability?.friday as Any,
            "saturday": self.availability?.saturday as Any,
            "sunday" : self.availability?.sunday as Any
        ] as [String: Any]
        let profileRef = Database.database().reference().child("userProfile").child(uid)
        profileRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print("Could not save profile", error ?? "unknown error")
                return
            }
            //move on to next window
            let layout = UICollectionViewFlowLayout()
            let availabilityCollectionView = AvailabilityCollectionViewController(collectionViewLayout: layout)
            let navAvailabilityCollectionView = UINavigationController(rootViewController: availabilityCollectionView)
            self.present(navAvailabilityCollectionView, animated: true, completion: {
                print("Success")
            })
        }
    }
    
}
