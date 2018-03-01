//
//  SettingsViewController.swift
//  Optie
//
//  Created by Rey Cerio on 2018-02-10.
//  Copyright © 2018 Rey Cerio. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    var settingsValues = SettingsValues()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.masksToBounds = true
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Set the parameters of your search:"
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Max distance in kilometers:"
        return label
    }()
    
    let skillLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Skill Level:"
        return label
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Gender:"
        return label
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Age Range:"
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Edit Bio:"
        return label
    }()
    
    let distanceSegmentControl: UISegmentedControl = {
        let segCon = UISegmentedControl(items: ["25", "50", "100"])
        segCon.tintColor = .white
        segCon.selectedSegmentIndex = 0
        return segCon
    }()
    
    let genderSegmentControl: UISegmentedControl = {
        let segCon = UISegmentedControl(items: ["female", "male", "both"])
        segCon.tintColor = .white
        segCon.selectedSegmentIndex = 0
        return segCon
    }()
    
    lazy var skillLevelSlider: UISlider = {
        let slider = UISlider()
        slider.isUserInteractionEnabled = true
        slider.value = 1
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.addTarget(self, action: #selector(skillSliderValue), for: .valueChanged)
        return slider
    }()
    
    lazy var ageLevelSlider: UISlider = {
        let slider = UISlider()
        slider.isUserInteractionEnabled = true
        slider.value = 1
        slider.minimumValue = 19
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(ageSliderValue), for: .valueChanged)
        return slider
    }()
    
    let bioTextView: UITextView = {
        let tv = UITextView()
        return tv
    }()
    
    @objc func skillSliderValue() {
        skillLevelSlider.value = roundf(self.skillLevelSlider.value)
        let skill = roundf(skillLevelSlider.value)
        self.settingsValues.skillValue = Int(skill)
    }
    
    @objc func ageSliderValue() {
        let age = roundf(ageLevelSlider.value)
        self.settingsValues.ageValue = Int(age)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        navigationItem.title = "Settings"
        view.backgroundColor = self.view.tintColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        view.addSubview(containerView)
        containerView.anchors(top: view.safeTopAnchor, bottom: view.safeBottomAnchor, left: view.safeLeftAnchor, right: view.safeRightAnchor, paddingTop: 10, paddingBottom: -10, paddingLeft: 10, paddingRight: -10)
        
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(distanceLabel)
        containerView.addSubview(distanceSegmentControl)
        containerView.addSubview(skillLabel)
        containerView.addSubview(skillLevelSlider)
        containerView.addSubview(genderLabel)
        containerView.addSubview(genderSegmentControl)
        containerView.addSubview(ageLabel)
        containerView.addSubview(ageLevelSlider)
        containerView.addSubview(bioTextView)
        containerView.addSubview(bioLabel)
        
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(300)]", views: descriptionLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(300)]", views: bioLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: bioTextView)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(300)]", views: distanceLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: distanceSegmentControl)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(300)]", views: genderLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: genderSegmentControl)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(300)]", views: skillLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: skillLevelSlider)
        containerView.addConstraintsWithVisualFormat(format: "H:|-20-[v0(300)]", views: ageLabel)
        containerView.addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: ageLevelSlider)
        
        
        containerView.addConstraintsWithVisualFormat(format: "V:|-10-[v0(40)]-20-[v1(30)]-4-[v2(90)]-20-[v3(30)]-4-[v4(30)]-10-[v5(30)]-4-[v6(30)]-10-[v7(30)]-4-[v8(30)]-10-[v9(30)]-4-[v10(30)]", views: descriptionLabel, bioLabel, bioTextView, distanceLabel, distanceSegmentControl, genderLabel, genderSegmentControl, skillLabel, skillLevelSlider, ageLabel, ageLevelSlider)
    }
    
    @objc func handleBack() {
        
        self.settingsValues.gender = genderSegmentControl.titleForSegment(at: genderSegmentControl.selectedSegmentIndex)!
        let distance = distanceSegmentControl.titleForSegment(at: distanceSegmentControl.selectedSegmentIndex)! as NSString
        self.settingsValues.distance = distance.doubleValue
        let skill: Int = Int(round(skillLevelSlider.value))
        self.settingsValues.skillValue = skill
        self.settingsValues.ageValue = Int(ageLevelSlider.value)
        guard let bio = bioTextView.text else {return}
        self.settingsValues.bio = bio
        
        let defaults = UserDefaults()
        defaults.set(self.settingsValues.gender, forKey: "gender")
        defaults.set(distance, forKey: "distance")
        defaults.set(skill, forKey: "skillValue")
        defaults.set(self.settingsValues.ageValue, forKey: "ageValue")
        defaults.set(bio, forKey: "bio")
  
        let tabBarController = TabBarController()
        tabBarController.settingsValues = self.settingsValues   //put this here so it happens before the viewDidAppear
        self.present(tabBarController, animated: true) {
            //dont pass data here if you need it before the viewdidappear
        }
    }
    
}
