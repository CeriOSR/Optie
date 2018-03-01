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

class AvailabilityCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    var timer = Timer()
    weak var availabilityController : AvailabilityCollectionViewController?
    private  let dayCell = "dayCell"
    var availableUsers = UsersDayList()
    var availability = AvailabilityModel()
    var skill = SkillLevelModel()
    var users = [OptieUser](){
        didSet{
            for user in users {
                guard let urlString = user.imageUrl else {return}
                self.returnImage(urlString: urlString)
            }
            DispatchQueue.main.async(execute: {
                self.dayCollectionView.reloadData()
            })
        }
    }
    
    ///////////////////////////////////////-PREFETCHING FUNCTIONS IMAGES- ///////////////////////////////////////////////////////////////////////////////////
    
    var imageArray = [UIImage?]()
    var tasks = [URLSessionDataTask?]()
    
    func urlComponents(index: Int) -> URL {
        
        var baseUrl = URL(string: "placeholder")
        guard let url = users[index].imageUrl else {return baseUrl!}
        baseUrl = URL(string: url)
        return baseUrl!
    }
    
    func getTask(forIndex: IndexPath, imageUrl: String) -> URLSessionDataTask {

        let imgURL = urlComponents(index: forIndex.item)
        return URLSession.shared.dataTask(with: imgURL, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {return}
            
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data)!
                self.imageArray[forIndex.item] = image
//                self.imageArray.append(image)
                self.dayCollectionView.reloadItems(at: [forIndex])
            })
        })
    }
    
    func requestImage(forIndex: IndexPath, imageUrl: String) {
        var task: URLSessionDataTask
        if imageArray[forIndex.row] != nil {
            // Image is already loaded
            return
        }
        if self.tasks[forIndex.row] != nil
            && self.tasks[forIndex.row]!.state == URLSessionTask.State.running {
            // Wait for task to finish
            return
        }
        task = getTask(forIndex: forIndex, imageUrl: imageUrl)
        tasks[forIndex.row] = task
        task.resume()
    }
    
    func returnImage(urlString: String) {
        var img : UIImage?
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    img = downloadedImage
                    self.imageArray.append(img!)
                    self.dayCollectionView.reloadData()
                }
            }
        }).resume()
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
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
        super.setupViews()
        dayCollectionView.prefetchDataSource = self
        
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
        
        
        if let userId = user.uid {
            fetchUserAvailabilityAndSkill(userId: userId)
        }
        if availability.haveCar == true {
            cell.carImageView.isHidden = false
            cell.carImageView.image = UIImage(named: "CAR_SMALL")?.withRenderingMode(.alwaysOriginal)
        } else {
            cell.carImageView.isHidden = true
        }
        if let gender = user.gender?.first, let age = user.age {
            
                let genderAndAge = "\(gender)" + ", " + "\(String(describing: age))"
                cell.genderAgeLabel.text = genderAndAge
        }
        if let skill = self.skill.skillLevel {
            cell.skillLabel.text = String(describing: skill)
        }
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
//        for indexPath in indexPaths {
//            let user = users[indexPath.item]
//            guard let imageUrl = user.imageUrl else {return}
//            let cell = dayCollectionView.dequeueReusableCell(withReuseIdentifier: dayCell, for: indexPath) as! DayCell
//            cell.userImage.loadEventImageUsingCacheWithUrlString(urlString: imageUrl)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
////            if let task = tasks[indexPath.row] {
////                if task.state != URLSessionTask.State.canceling {
////                    task.cancel()
////                }
////            }
//        }
    }
    
    private func fetchUserAvailabilityAndSkill(userId: String) {
        let userProfileRef = Database.database().reference().child("userProfile").child(userId)
        userProfileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String:Any]
            self.availability.bio = dictionary["bio"] as? String
            self.availability.haveCar = dictionary["haveCar"] as? Bool
            self.availability.userType = dictionary["userType"] as? String
            self.availability.monday = dictionary["monday"] as? Bool
            self.availability.tuesday = dictionary["tuesday"] as? Bool
            self.availability.wednesday = dictionary["wednesday"] as? Bool
            self.availability.thursday = dictionary["thursday"] as? Bool
            self.availability.friday = dictionary["friday"] as? Bool
            self.availability.saturday = dictionary["saturday"] as? Bool
            self.availability.sunday = dictionary["sunday"] as? Bool
            self.skill.skillLevel = dictionary["skillLevel"] as? Int
            self.skill.skillQ1 = dictionary["skillQ1"] as? Bool
            self.skill.skillQ2 = dictionary["skillQ2"] as? Bool
            self.skill.skillQ3 = dictionary["skillQ3"] as? Bool
            self.skill.skillQ4 = dictionary["skillQ4"] as? Bool
            self.skill.skillQ5 = dictionary["skillQ5"] as? Bool
            
        }, withCancel: nil)
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
    
    let carImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isHidden = true
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 14
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
        label.layer.cornerRadius = 14
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
    
    
    override func setupViews() {
        backgroundColor = UIColor(r: 13, g: 31, b: 61)
        addSubview(nameLabel)
        addSubview(userImage)
        addSubview(genderAgeLabel)
        addSubview(skillLabel)
        addSubview(carImageView)
        
        addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: nameLabel)
        addConstraintsWithVisualFormat(format: "H:|-10-[v0(70)]|", views: userImage)
        addConstraintsWithVisualFormat(format: "V:|-36-[v0(70)]", views: userImage)
        addConstraintsWithVisualFormat(format: "V:[v0(40)]-10-|", views: nameLabel)
        
        skillLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 36).isActive = true
        skillLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        skillLabel.widthAnchor.constraint(equalToConstant: 28).isActive = true
        skillLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        carImageView.topAnchor.constraint(equalTo: skillLabel.bottomAnchor, constant: 10).isActive = true
        carImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        carImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        carImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        genderAgeLabel.topAnchor.constraint(equalTo: carImageView.bottomAnchor, constant: 10).isActive = true
        genderAgeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        genderAgeLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        genderAgeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        userImage.image = nil
        skillLabel.text = ""
        carImageView.image = nil
        genderAgeLabel.text = ""
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


