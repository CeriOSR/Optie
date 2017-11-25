//
//  SkillLevelController.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-12.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit

class SkillLevelController: UIViewController {
    
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
        image.image = UIImage(named: "Logo")
        return image
    }()
    
    let skillLevelSlider: UISlider = {
        let slider = UISlider()
        slider.isUserInteractionEnabled = true
        slider.minimumValue = 1
        slider.maximumValue = 5
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
    
    @objc func handleSubmit() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Profile"
        
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
}
