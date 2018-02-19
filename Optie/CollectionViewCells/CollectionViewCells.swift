//
//  CollectionViewCells.swift
//  Optie
//
//  Created by Rey Cerio on 2017-12-17.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}

class AvailabilityCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var timer = Timer()
    var availabilityController : AvailabilityCollectionViewController?
    private  let dayCell = "dayCell"
    var availableUsers = UsersDayList()
    var users = [OptieUser](){
        didSet{
            DispatchQueue.main.async(execute: {
                self.dayCollectionView.reloadData()
            })
        }
    }
    let dayLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .red
        cv.isScrollEnabled = true
        cv.showsHorizontalScrollIndicator = true
        cv.layer.cornerRadius = 10
        cv.layer.masksToBounds = true
        return cv
    }()
    
    override func setupViews() {
        
        dayCollectionView.backgroundColor = UIColor(r: 24, g: 56, b: 98)
        addSubview(dayCollectionView)
        addSubview(dayLabel)
        
        dayCollectionView.register(DayCell.self, forCellWithReuseIdentifier: dayCell)
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        
        addConstraintsWithVisualFormat(format: "H:|-4-[v0(200)]", views: dayLabel)
        addConstraintsWithVisualFormat(format: "H:|-8-[v0]-8-|", views: dayCollectionView)
        addConstraintsWithVisualFormat(format: "V:|-2-[v0]-2-[v1]-2-|", views: dayLabel, dayCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dayCell, for: indexPath) as! DayCell
        let user: OptieUser = self.users[indexPath.item]
        cell.nameLabel.text = user.name
        guard let imageUrl = user.imageUrl else {return cell}
        cell.userImage.loadEventImageUsingCacheWithUrlString(urlString: imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 4, 0, 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = self.users[indexPath.item]
        availabilityController?.showChosenUserController(user: user)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dayLabel.text = ""
    }
}

class DayCell: BaseCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let userImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.image = #imageLiteral(resourceName: "PROFILE_DARK")
        image.layer.cornerRadius = 35
        image.layer.masksToBounds = true
        return image
    }()
    
    
    override func setupViews() {
        backgroundColor = UIColor(r: 13, g: 31, b: 61)
        addSubview(nameLabel)
        addSubview(userImage)
        
        addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: nameLabel)
        addConstraintsWithVisualFormat(format: "H:|-10-[v0(70)]|", views: userImage)
        addConstraintsWithVisualFormat(format: "V:|-36-[v0(70)]", views: userImage)
        addConstraintsWithVisualFormat(format: "V:[v0(40)]-10-|", views: nameLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        userImage.image = nil
    }
}

class MessageListCell: BaseCell {
    
    var message = Message() {
        didSet{
            guard let reciever = message.reciever else {return}
            let userRef = Database.database().reference().child("user").child(reciever)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String: Any]
                var user = OptieUser()
                user.name = dictionary["name"] as? String
                user.imageUrl = dictionary["imageUrl"] as? String
                DispatchQueue.main.async(execute: {
                    self.userNameLabel.text = user.name
                    self.userImage.loadEventImageUsingCacheWithUrlString(urlString: user.imageUrl!)
                })
            }, withCancel: nil)
        }
    }
    
    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        return container
    }()
    
    let userImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 32
        image.layer.masksToBounds = true
        image.image = #imageLiteral(resourceName: "PROFILE_DARK")
        return image
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(16)
        label.textColor = .white
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font.withSize(8)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray
        label.textColor = .white
        label.font.withSize(8)
        label.text = "HH:MM:SS AA"
        return label
    }()
    
    override func setupViews() {
        
        addSubview(containerView)
        containerView.addSubview(userImage)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(messageLabel)
//        containerView.addSubview(dateLabel)
        
        //TRY USING ANCHORS FOR CONTAINERVIEW
        containerView.anchors(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 6, paddingRight: -6)
        
        userImage.anchors(top: containerView.topAnchor, bottom: containerView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 6, paddingBottom: -6, paddingLeft: 10, paddingRight: -290)
        userNameLabel.anchors(top: containerView.topAnchor, bottom: containerView.bottomAnchor, left: userImage.rightAnchor, right: containerView.safeRightAnchor, paddingTop: 2, paddingBottom: -20, paddingLeft: 4, paddingRight: -18, height: 30)
        messageLabel.anchors(top: userNameLabel.bottomAnchor, bottom: containerView.bottomAnchor, left: userImage.rightAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 4, paddingRight: -90)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        userImage.image = nil
    }
}

class NewMessageCell: BaseCell {
    
    var message : Message?
    var user : OptieUser?
    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        return container
    }()
    
    let userImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 26
        image.layer.masksToBounds = true
        return image
    }()
    
    let chatTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        tv.textColor = .white
        return tv
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        userImage.image = nil
        chatTextView.text = nil
    }
}
