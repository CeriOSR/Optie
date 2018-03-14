//
//  ProfileCell.swift
//  Optie
//
//  Created by Rey Cerio on 2018-02-19.
//  Copyright © 2018 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase

class ProfileCell: BaseCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.masksToBounds = true
        return view
    }()
    
    let sportsLabel: UILabel = {
        let label = UILabel()
        label.text = "Do you Ski or Snowboard?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let sportsSegmentControl: UISegmentedControl = {
        let segCon = UISegmentedControl(items: ["Snowboard", "Ski", "Both"])
        segCon.tintColor = .white
        segCon.selectedSegmentIndex = 0
        return segCon
    }()
    
    let carLabel: UILabel = {
        let label = UILabel()
        label.text = "Do you own a car?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let carSegmentControl: UISegmentedControl = {
        let segCon = UISegmentedControl(items: ["Yes", "No"])
        segCon.tintColor = .white
        segCon.selectedSegmentIndex = 0
        return segCon
    }()
    
    let availabilityLabel: UILabel = {
        let label = UILabel()
        label.text = "What days are you free to ride?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let skillLevelImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo")
        return image
    }()
    
    let mondayLabel: UILabel = {
        let label = UILabel()
        label.text = "MONDAY"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let tuesdayLabel: UILabel = {
        let label = UILabel()
        label.text = "TUESDAY"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let wednesdayLabel: UILabel = {
        let label = UILabel()
        label.text = "WEDNESDAY"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let thursdayLabel: UILabel = {
        let label = UILabel()
        label.text = "THURSDAY"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let fridayLabel: UILabel = {
        let label = UILabel()
        label.text = "FRIDAY"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let saturdayLabel: UILabel = {
        let label = UILabel()
        label.text = "SATURDAY"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let sundayLabel: UILabel = {
        let label = UILabel()
        label.text = "SUNDAY"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let mondaySwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    let tuesdaySwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    let wednesdaySwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    let thursdaySwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    let fridaySwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    let saturdaySwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    let sundaySwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        return switchButton
    }()
    
    lazy var submitButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Next").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = UIColor(r: 0, g: 122, b: 255)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    //----------------------------------------------------------------------------------------------------------------------
    
    let skillLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "SKILL LEVEL:"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let skillLevelImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 6
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var skillLevelSlider: UISlider = {
        let slider = UISlider()
        slider.value = 1
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(changeSliderValue), for: .valueChanged)
        return slider
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "WHAT TYPE ARE YOU?:"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let typeLabel1: UILabel = {
        let label = UILabel()
        label.text = "I like to stop for hot chocolate."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel2: UILabel = {
        let label = UILabel()
        label.text = "I pack a lunch."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel3: UILabel = {
        let label = UILabel()
        label.text = "I like to ride park."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel4: UILabel = {
        let label = UILabel()
        label.text = "I'm interested in off piste."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel5: UILabel = {
        let label = UILabel()
        label.text = "I would skip work for good snow."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeSwitch1: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }()
    
    let typeSwitch2: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }()
    
    let typeSwitch3: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }()
    
    let typeSwitch4: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }()
    
    let typeSwitch5: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.setOn(true, animated: true)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }()
    
//    lazy var submitButton : UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "Next").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.backgroundColor = self.view.tintColor
//        button.setTitleColor(.white, for: .normal)
//        button.layer.borderWidth = 1.0
//        button.layer.borderColor = UIColor.lightGray.cgColor
//        button.layer.cornerRadius = 4
//        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
//        return button
//    }()
    
    //---------------------------------------------------------------------------------------------------------
    let bioTextView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 6
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "EDIT BIO:"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override func setupViews() {
        backgroundColor = UIColor(r: 0, g: 122, b: 255)
        addSubview(containerView)
        containerView.anchors(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingBottom: -10, paddingLeft: 10, paddingRight: -10)
        
        containerView.addSubview(sportsLabel)
        containerView.addSubview(sportsSegmentControl)
        containerView.addSubview(carLabel)
        containerView.addSubview(carSegmentControl)
        containerView.addSubview(availabilityLabel)
        containerView.addSubview(mondayLabel)
        containerView.addSubview(mondaySwitch)
        containerView.addSubview(tuesdayLabel)
        containerView.addSubview(tuesdaySwitch)
        containerView.addSubview(wednesdayLabel)
        containerView.addSubview(wednesdaySwitch)
        containerView.addSubview(thursdayLabel)
        containerView.addSubview(thursdaySwitch)
        containerView.addSubview(fridayLabel)
        containerView.addSubview(fridaySwitch)
        containerView.addSubview(saturdayLabel)
        containerView.addSubview(saturdaySwitch)
        containerView.addSubview(sundayLabel)
        containerView.addSubview(sundaySwitch)
        
        //------------------------------------
        
        containerView.addSubview(skillLevelLabel)
        containerView.addSubview(skillLevelImageView)
        containerView.addSubview(skillLevelSlider)
//        containerView.addSubview(typeLabel)
        containerView.addSubview(typeLabel1)
        containerView.addSubview(typeSwitch1)
        containerView.addSubview(typeLabel2)
        containerView.addSubview(typeSwitch2)
        containerView.addSubview(typeLabel3)
        containerView.addSubview(typeSwitch3)
        containerView.addSubview(typeLabel4)
        containerView.addSubview(typeSwitch4)
        containerView.addSubview(typeLabel5)
        containerView.addSubview(typeSwitch5)
//        containerView.addSubview(submitButton)
        
        //----------------------------------------------------------------------------------------------------------
        addSubview(bioLabel)
        addSubview(bioTextView)
        
        //HORIZONTAL
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: sportsLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: sportsSegmentControl)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: carLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: carSegmentControl)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: availabilityLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: mondayLabel, mondaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: tuesdayLabel, tuesdaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: wednesdayLabel, wednesdaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: thursdayLabel, thursdaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: fridayLabel, fridaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: saturdayLabel, saturdaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: sundayLabel, sundaySwitch)
//        containerView.addConstraintsWithVisualFormat(format: "H:[v0(100)]-10-|", views: submitButton)
        
        //VERTICAL
        containerView.addConstraintsWithVisualFormat(format: "V:|-10-[v0(20)]-6-[v1(30)]-10-[v2(20)]-6-[v3(30)]-30-[v4(20)]", views: sportsLabel, sportsSegmentControl, carLabel, carSegmentControl, availabilityLabel)
        containerView.addConstraintsWithVisualFormat(format: "V:|-204-[v0(20)]", views: mondayLabel)
        containerView.addConstraintsWithVisualFormat(format: "V:|-200-[v0]", views: mondaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "V:|-244-[v0(20)]", views: tuesdayLabel)
        containerView.addConstraintsWithVisualFormat(format: "V:|-240-[v0]", views: tuesdaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "V:|-284-[v0(20)]", views: wednesdayLabel)
        containerView.addConstraintsWithVisualFormat(format: "V:|-280-[v0]", views: wednesdaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "V:|-324-[v0(20)]", views: thursdayLabel)
        containerView.addConstraintsWithVisualFormat(format: "V:|-320-[v0]", views: thursdaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "V:|-364-[v0(20)]", views: fridayLabel)
        containerView.addConstraintsWithVisualFormat(format: "V:|-360-[v0]", views: fridaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "V:|-404-[v0(20)]", views: saturdayLabel)
        containerView.addConstraintsWithVisualFormat(format: "V:|-400-[v0]", views: saturdaySwitch)
        containerView.addConstraintsWithVisualFormat(format: "V:|-444-[v0(20)]", views: sundayLabel)
        containerView.addConstraintsWithVisualFormat(format: "V:|-440-[v0]", views: sundaySwitch)
//        containerView.addConstraintsWithVisualFormat(format: "V:[v0(45)]-10-|", views: submitButton)
        
        //---------------------------------------------------------------------------------------------------------------
        bioLabel.topAnchor.constraint(equalTo: sundaySwitch.bottomAnchor, constant: 30).isActive = true
        bioLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        bioTextView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 10).isActive = true
        bioTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        bioTextView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        bioTextView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        skillLevelLabel.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20).isActive = true
        skillLevelLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        skillLevelLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        skillLevelLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        skillLevelImageView.topAnchor.constraint(equalTo: skillLevelLabel.bottomAnchor, constant: 10).isActive = true
        skillLevelImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        skillLevelImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        skillLevelImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        skillLevelSlider.topAnchor.constraint(equalTo: skillLevelImageView.bottomAnchor, constant: 20).isActive = true
        skillLevelSlider.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        skillLevelSlider.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        skillLevelSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeSwitch1.topAnchor.constraint(equalTo: skillLevelSlider.bottomAnchor, constant: 50).isActive = true
        typeSwitch1.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        typeSwitch1.widthAnchor.constraint(equalToConstant: 50).isActive = true
        typeSwitch1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeLabel1.topAnchor.constraint(equalTo: skillLevelSlider.bottomAnchor, constant: 54).isActive = true
        typeLabel1.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        typeLabel1.rightAnchor.constraint(equalTo: typeSwitch1.leftAnchor, constant: -10).isActive = true
        typeLabel1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeSwitch2.topAnchor.constraint(equalTo: typeSwitch1.bottomAnchor, constant: 20).isActive = true
        typeSwitch2.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        typeSwitch2.widthAnchor.constraint(equalToConstant: 50).isActive = true
        typeSwitch2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeLabel2.topAnchor.constraint(equalTo: typeLabel1.bottomAnchor, constant: 20).isActive = true
        typeLabel2.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        typeLabel2.rightAnchor.constraint(equalTo: typeSwitch2.leftAnchor, constant: -10).isActive = true
        typeLabel2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeSwitch3.topAnchor.constraint(equalTo: typeSwitch2.bottomAnchor, constant: 20).isActive = true
        typeSwitch3.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        typeSwitch3.widthAnchor.constraint(equalToConstant: 50).isActive = true
        typeSwitch3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeLabel3.topAnchor.constraint(equalTo: typeLabel2.bottomAnchor, constant: 20).isActive = true
        typeLabel3.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        typeLabel3.rightAnchor.constraint(equalTo: typeSwitch3.leftAnchor, constant: -10).isActive = true
        typeLabel3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeSwitch4.topAnchor.constraint(equalTo: typeSwitch3.bottomAnchor, constant: 20).isActive = true
        typeSwitch4.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        typeSwitch4.widthAnchor.constraint(equalToConstant: 50).isActive = true
        typeSwitch4.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeLabel4.topAnchor.constraint(equalTo: typeLabel3.bottomAnchor, constant: 20).isActive = true
        typeLabel4.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        typeLabel4.rightAnchor.constraint(equalTo: typeSwitch4.leftAnchor, constant: -10).isActive = true
        typeLabel4.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeSwitch5.topAnchor.constraint(equalTo: typeSwitch4.bottomAnchor, constant: 20).isActive = true
        typeSwitch5.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        typeSwitch5.widthAnchor.constraint(equalToConstant: 50).isActive = true
        typeSwitch5.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeLabel5.topAnchor.constraint(equalTo: typeLabel4.bottomAnchor, constant: 20).isActive = true
        typeLabel5.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        typeLabel5.rightAnchor.constraint(equalTo: typeSwitch4.leftAnchor, constant: -10).isActive = true
        typeLabel5.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func changeSliderValue() {
        skillLevelSlider.value = roundf(self.skillLevelSlider.value)
        let skill = round(skillLevelSlider.value)
        let sports = sportsSegmentControl.titleForSegment(at: sportsSegmentControl.selectedSegmentIndex)
        if sports == "Snowboard" {
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
        } else if sports == "Ski" || sports == "Both"{
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
    
    func setSkillModel() -> SkillLevelModel {
        var skillLevel = SkillLevelModel()
        
        if self.typeSwitch1.isEnabled == true {
            skillLevel.skillQ1 = true
        } else {
            skillLevel.skillQ1 = false
        }
        if self.typeSwitch2.isOn == true {
            skillLevel.skillQ2 = true
        } else {
            skillLevel.skillQ2 = false
        }
        if self.typeSwitch3.isOn == true {
            skillLevel.skillQ3 = true
        } else {
            skillLevel.skillQ3 = false
        }
        if self.typeSwitch4.isOn == true {
            skillLevel.skillQ4 = true
        } else {
            skillLevel.skillQ4 = false
        }
        if self.typeSwitch5.isOn == true {
            skillLevel.skillQ5 = true
        } else {
            skillLevel.skillQ5 = false
        }
        return skillLevel
    }
    
    func setAvailabilityModel() -> AvailabilityModel {
        var availability = AvailabilityModel()
        availability.userType = sportsSegmentControl.titleForSegment(at: sportsSegmentControl.selectedSegmentIndex)
        if carSegmentControl.selectedSegmentIndex == 0 {
            availability.haveCar = true
        } else {
            availability.haveCar = false
        }
        if mondaySwitch.isOn == true {
            availability.monday = true
        } else {
            availability.monday = false
        }
        if tuesdaySwitch.isOn == true {
            availability.tuesday = true
        } else {
            availability.tuesday = false
        }
        if wednesdaySwitch.isOn == true {
            availability.wednesday = true
        } else {
            availability.wednesday = false
        }
        if thursdaySwitch.isOn == true {
            availability.thursday = true
        } else {
            availability.thursday = false
        }
        if fridaySwitch.isOn == true {
            availability.friday = true
        } else {
            availability.friday = false
        }
        if saturdaySwitch.isOn == true {
            availability.saturday = true
        } else {
            availability.saturday = false
        }
        if sundaySwitch.isOn == true {
            availability.sunday = true
        } else {
            availability.sunday = false
        }
        
        return availability
    }
    
    func saveProfileToDatabase(){
        let skillLevel = setSkillModel()
        let availability = setAvailabilityModel()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [
            "bio": bioTextView.text,
            "skillLevel": roundf(skillLevelSlider.value),
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
            } else {
                availabilityRef.child("Monday").child(uid).removeValue()
            }
            
            if availability.tuesday == true {
                availabilityRef.child("Tuesday").updateChildValues([uid:"Tuesday"])
            }else {
                availabilityRef.child("Monday").child(uid).removeValue()
            }
            
            if availability.wednesday == true {
                availabilityRef.child("Wednesday").updateChildValues([uid:"Wednesday"])
            }else {
                availabilityRef.child("Monday").child(uid).removeValue()
            }
            
            if availability.thursday == true {
                availabilityRef.child("Thursday").updateChildValues([uid:"Thursday"])
            }else {
                availabilityRef.child("Monday").child(uid).removeValue()
            }
            
            if availability.friday == true {
                availabilityRef.child("Friday").updateChildValues([uid:"Friday"])
            }else {
                availabilityRef.child("Monday").child(uid).removeValue()
            }
            
            if availability.saturday == true {
                availabilityRef.child("Saturday").updateChildValues([uid:"Saturday"])
            }else {
                availabilityRef.child("Monday").child(uid).removeValue()
            }
            
            if availability.sunday == true {
                availabilityRef.child("Sunday").updateChildValues([uid:"Sunday"])
            }else {
                availabilityRef.child("Monday").child(uid).removeValue()
            }
        }
    }
}
