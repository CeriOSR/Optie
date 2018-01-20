//
//  SportsController.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-12.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase

class SportsController: UIViewController {
    
    let profileController = ProfileController()
    var user : OptieUser? {
        didSet{
            navigationItem.title = self.user?.email ?? "NIL"
        }
    }
    var availability = AvailabilityModel()
    
    
    let sportsContainerView: UIView = {
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
    
    lazy var proceedButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Next").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = self.view.tintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(presentSkillLevelControllerWithAvailabilityVariable), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViews()
    }
    
    @objc func presentSkillLevelControllerWithAvailabilityVariable() {
        
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
                
        let skillLevelController = SkillLevelController()
        let navSkillLevelController = UINavigationController(rootViewController: skillLevelController)
        self.present(navSkillLevelController, animated: true) {
            skillLevelController.availability = self.availability
        }
    }
    
    @objc func handleBack() {
        let profileController = ProfileController()
        let navProfileController = UINavigationController(rootViewController: profileController)
        self.present(navProfileController, animated: true, completion: nil)
    }
    
    func setupViews() {
        view.backgroundColor = self.view.tintColor
//        navigationItem.title = "Profile"
        navigationController?.navigationBar.backgroundColor = self.view.tintColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        view.addSubview(sportsContainerView)
//        let height = view.frame.height - 75
//        let y = view.frame.height - height
//        sportsContainerView.frame = CGRect(x: 8, y: y, width: view.frame.width - 16, height: height)

//        view.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: sportsContainerView)
//        view.addConstraintsWithVisualFormat(format: "V:|-100-[v0]-20-|", views: sportsContainerView)

        sportsContainerView.anchors(top: view.safeTopAnchor, bottom: view.safeBottomAnchor, left: view.safeLeftAnchor, right: view.safeRightAnchor, paddingTop: 10, paddingBottom: -10, paddingLeft: 10, paddingRight: -10)
        
        sportsContainerView.addSubview(sportsLabel)
        sportsContainerView.addSubview(sportsSegmentControl)
        sportsContainerView.addSubview(carLabel)
        sportsContainerView.addSubview(carSegmentControl)
        sportsContainerView.addSubview(availabilityLabel)
        sportsContainerView.addSubview(mondayLabel)
        sportsContainerView.addSubview(mondaySwitch)
        sportsContainerView.addSubview(tuesdayLabel)
        sportsContainerView.addSubview(tuesdaySwitch)
        sportsContainerView.addSubview(wednesdayLabel)
        sportsContainerView.addSubview(wednesdaySwitch)
        sportsContainerView.addSubview(thursdayLabel)
        sportsContainerView.addSubview(thursdaySwitch)
        sportsContainerView.addSubview(fridayLabel)
        sportsContainerView.addSubview(fridaySwitch)
        sportsContainerView.addSubview(saturdayLabel)
        sportsContainerView.addSubview(saturdaySwitch)
        sportsContainerView.addSubview(sundayLabel)
        sportsContainerView.addSubview(sundaySwitch)
        sportsContainerView.addSubview(proceedButton)

        //HORIZONTAL
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: sportsLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: sportsSegmentControl)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: carLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: carSegmentControl)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0]-20-|", views: availabilityLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: mondayLabel, mondaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: tuesdayLabel, tuesdaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: wednesdayLabel, wednesdaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: thursdayLabel, thursdaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: fridayLabel, fridaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: saturdayLabel, saturdaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(150)]-50-[v1(50)]-10-|", views: sundayLabel, sundaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "H:[v0(100)]-10-|", views: proceedButton)
        
        //VERTICAL
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-10-[v0(20)]-6-[v1(30)]-10-[v2(20)]-6-[v3(30)]-30-[v4(20)]", views: sportsLabel, sportsSegmentControl, carLabel, carSegmentControl, availabilityLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-204-[v0(20)]", views: mondayLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-200-[v0]", views: mondaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-244-[v0(20)]", views: tuesdayLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-240-[v0]", views: tuesdaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-284-[v0(20)]", views: wednesdayLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-280-[v0]", views: wednesdaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-324-[v0(20)]", views: thursdayLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-320-[v0]", views: thursdaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-364-[v0(20)]", views: fridayLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-360-[v0]", views: fridaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-404-[v0(20)]", views: saturdayLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-400-[v0]", views: saturdaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-444-[v0(20)]", views: sundayLabel)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:|-440-[v0]", views: sundaySwitch)
        sportsContainerView.addConstraintsWithVisualFormat(format: "V:[v0(45)]-10-|", views: proceedButton)
    }
    
//    @objc func saveToDatabase() {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        availability.userType = sportsSegmentControl.titleForSegment(at: sportsSegmentControl.selectedSegmentIndex)
//        if carSegmentControl.selectedSegmentIndex == 0 {
//            availability.haveCar = true
//        }
//        let values = ["userType": availability.userType!, "hasCar": availability.haveCar!] as [String : Any]
//        let dataRef = Database.database().reference().child("SportsAndAvailability").child(uid)
//        dataRef.updateChildValues(values) { (error, ref) in
//            if error != nil {
//                print("FAILED TO SAVE TO DATABASE", error ?? "unknown error")
//            } else {
//                let skillLevelController = SkillLevelController()
//                let navSkillLevelController = UINavigationController(rootViewController: skillLevelController)
//                self.present(navSkillLevelController, animated: true, completion: nil)
//            }
//        }
//    }
}
