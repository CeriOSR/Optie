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
    
    private  let dayCell = "dayCell"
    var availableUsers = UsersDayList()
    var users = [OptieUser](){
        didSet{
            
            //PUT A TIMER ON RELOAD HERE
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
        return CGSize(width: 140, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 4, 0, 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //go to clicked user's profile here.
    }
    
    override func prepareForReuse() {
        self.dayLabel.text = ""
    }
}

class DayCell: BaseCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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
        addConstraintsWithVisualFormat(format: "H:|-34-[v0(70)]|", views: userImage)
        addConstraintsWithVisualFormat(format: "V:|-36-[v0(70)]", views: userImage)
        addConstraintsWithVisualFormat(format: "V:[v0(40)]-10-|", views: nameLabel)
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        userImage.image = #imageLiteral(resourceName: "PROFILE_DARK")
    }
}

class MessageListCell: BaseCell {
    
    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        return container
    }()
    
    let userImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.layer.masksToBounds = true
        image.image = #imageLiteral(resourceName: "PROFILE_DARK")
        return image
    }()
    
    let messageView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        tv.textColor = .white
        tv.text = "I snowboard, surfboard, ski and all the good stuff in the worlds. Well no not really but I could do it..."
        return tv
    }()
    
    override func setupViews() {
        
        addSubview(containerView)
        containerView.addSubview(userImage)
        containerView.addSubview(messageView)
        
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: containerView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addConstraintsWithVisualFormat(format: "H:|-4-[v0(62)]-2-[v1]-4-|", views: userImage, messageView)
        containerView.addConstraintsWithVisualFormat(format: "V:|-4-[v0]-4-|", views: userImage)
        containerView.addConstraintsWithVisualFormat(format: "V:|-2-[v0]-2-|", views: messageView)
        
    }
}

class NewMessageCell: BaseCell {
    
    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        return container
    }()
    
    override func setupViews() {
        addSubview(containerView)
        
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: containerView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: containerView)
    }
}
