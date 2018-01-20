//
//  NewMessagesCollectionViewController.swift
//  Optie
//
//  Created by Rey Cerio on 2018-01-04.
//  Copyright © 2018 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class NewMessagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var timer = Timer()
    var messages = [Message]()
    let popupModel = PopupViewModel()
    var chosenUser: OptieUser? {
        didSet{
            navigationItem.title = chosenUser?.name
        }
    }
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        return cv
    }()
    
    let chatTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "message..."
        tf.textColor = .white
        return tf
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "SEND") , for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Messages", style: .plain, target: self, action: #selector(handleBack))
        collectionView?.backgroundColor = self.view.tintColor
        view.addSubview(containerView)
        containerView.anchors(top: collectionView?.safeBottomAnchor, bottom: view.safeBottomAnchor, left: view.safeLeftAnchor, right: view.safeRightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, height: 50)
        containerView.addSubview(chatTextField)
        containerView.addSubview(sendButton)
        containerView.addConstraintsWithVisualFormat(format: "H:|-2-[v0]-4-[v1(60)]-2-|", views: chatTextField, sendButton)
        containerView.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: chatTextField)
        containerView.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: sendButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        fetchMessages()
        self.collectionView!.register(NewMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
        fetchMessages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //empty the variables here
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = messages.count
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewMessageCell
        let message = self.messages[indexPath.item]
        guard let uid = Auth.auth().currentUser?.uid else {return cell}
        guard let chosenUser = self.chosenUser else {return cell}
        cell.message = message
        cell.user = chosenUser
        guard let imageUrl = chosenUser.imageUrl else {return cell}
        cell.userImage.loadEventImageUsingCacheWithUrlString(urlString: imageUrl)
        if let chat = message.message {
            cell.chatTextView.text = chat
        }
        setupCellWithUid(uid: uid, cell: cell, message: message)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    private func setupCellWithUid(uid: String, cell: NewMessageCell, message: Message) {
        cell.addSubview(cell.containerView)
        if message.sender == uid {
            cell.containerView.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.safeLeftAnchor, right: cell.safeRightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 75, paddingRight: 20)
            cell.containerView.addSubview(cell.chatTextView)
            cell.chatTextView.anchors(top: cell.containerView.topAnchor, bottom: cell.containerView.bottomAnchor, left: cell.containerView.leftAnchor, right: cell.containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0)
            
        } else {
            cell.containerView.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.safeLeftAnchor, right: cell.safeRightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: -10, paddingRight: -75)
            cell.containerView.addSubview(cell.chatTextView)
            cell.containerView.addSubview(cell.userImage)
            cell.userImage.anchors(top: cell.containerView.topAnchor, bottom: cell.containerView.bottomAnchor, left: cell.containerView.leftAnchor, right: cell.containerView.rightAnchor, paddingTop: 10, paddingBottom: -10, paddingLeft: 20, paddingRight: -240)
            cell.chatTextView.anchors(top: cell.containerView.topAnchor, bottom: cell.containerView.bottomAnchor, left: cell.userImage.rightAnchor, right: cell.containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0)
            
        }
    }
    
    @objc func handleBack() {
        let layout = UICollectionViewFlowLayout()
        let messageListController = MessageListController(collectionViewLayout: layout)
        let navMessageListController = UINavigationController(rootViewController: messageListController)
        present(navMessageListController, animated: true) {
            
        }
        
    }
    
    @objc func handleSend() {
        let randomId = NSUUID().uuidString
        guard let chosenUserUid = self.chosenUser?.uid else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let chatText = chatTextField.text else {popupModel.createAlert(title: "No message found.", message: "Please type a message.")
            return
        }
        let date = String(describing: Date())

        let values: [String: Any] = ["sender": uid, "reciever": chosenUserUid, "date": date, "message": chatText]
        let messageRef = Database.database().reference().child("messages").child(randomId)
        let senderMessageRef = Database.database().reference().child("messagesRef").child(uid)
        let recieverMessageRef = Database.database().reference().child("messagesRef").child(chosenUserUid)
//        let userContactsRef = Database.database().reference().child("contacts").child(uid)
//        let chosenUserContactRef = Database.database().reference().child("contacts").child(chosenUserUid)
        messageRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                self.popupModel.createAlert(title: "Message not sent.", message: "Error when sending message")
            }
            senderMessageRef.updateChildValues([randomId:1])
            recieverMessageRef.updateChildValues([randomId:1])
//            userContactsRef.updateChildValues([chosenUserUid:1])
//            chosenUserContactRef.updateChildValues([uid:1])
            self.chatTextField.text = ""
        }
    }
    
    private func fetchMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let currentUserMessageRef = Database.database().reference().child("messagesRef").child(uid)
        currentUserMessageRef.observe(.childAdded, with: { (snap) in
            let messageId = snap.key
            print(messageId)
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as? [String: Any]
                var message = Message()
                message.date = dictionary?["date"] as? String
                message.message = dictionary?["message"] as? String
                message.reciever = dictionary?["reciever"] as? String
                message.sender = dictionary?["sender"] as? String
                if message.sender == self.chosenUser?.uid || message.sender == uid {
                    if message.reciever == self.chosenUser?.uid || message.reciever == uid {
                        self.messages.append(message)
                    }
                }
//                self.timer.invalidate()
//                self.timer.fire()
//                self.timer = Timer(timeInterval: 0.2, repeats: false, block: { (timer) in
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
//                })
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
//    func fetchChosenUser() {
//        guard let reciever = message.reciever else {return}
//        let userRef = Database.database().reference().child("user").child(reciever)
//        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            let dictionary = snapshot.value as! [String: Any]
//            var user = OptieUser()
//            user.name = dictionary["name"] as? String
//            user.imageUrl = dictionary["imageUrl"] as? String
//            DispatchQueue.main.async(execute: {
//                self.userNameLabel.text = user.name
//                self.userImage.loadEventImageUsingCacheWithUrlString(urlString: user.imageUrl!)
//            })
//        }, withCancel: nil)
//    }

}
