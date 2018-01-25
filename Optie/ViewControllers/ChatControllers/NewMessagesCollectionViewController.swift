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
    
    let window = UIWindow(frame: UIScreen.main.bounds )
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
        tf.allowsEditingTextAttributes = true
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
        containerView.anchors(top: self.collectionView?.safeBottomAnchor, bottom: self.view.safeBottomAnchor, left: self.view.safeLeftAnchor, right: self.view.safeRightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, height: 50)
        containerView.addSubview(chatTextField)
        containerView.addSubview(sendButton)
        containerView.addConstraintsWithVisualFormat(format: "H:|-2-[v0]-4-[v1(60)]-2-|", views: chatTextField, sendButton)
        containerView.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: chatTextField)
        containerView.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: sendButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.collectionView!.register(NewMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.keyboardDismissMode = .interactive
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchMessages()
    }
    
//    override var inputAccessoryView: UIView?
//    {
//        get{
//            let containerView = UIView()
//            containerView.backgroundColor = .gray
//            containerView.translatesAutoresizingMaskIntoConstraints = false
//            containerView.frame = CGRect(x:0, y: 100, width: view.frame.width, height: 50)
////            containerView.bottomAnchor.constraintEqualToSystemSpacingBelow(self.view.safeBottomAnchor, multiplier: 0).isActive = true
////            containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
////            containerView.leftAnchor.constraintEqualToSystemSpacingAfter(self.view.safeLeftAnchor, multiplier: 0).isActive = true
////            containerView.rightAnchor.constraintEqualToSystemSpacingAfter(self.view.safeRightAnchor, multiplier: 0).isActive = true
//            containerView.addSubview(chatTextField)
//            containerView.addSubview(sendButton)
//            containerView.addConstraintsWithVisualFormat(format: "H:|-2-[v0]-4-[v1(60)]-2-|", views: chatTextField, sendButton)
//            containerView.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: chatTextField)
//            containerView.addConstraintsWithVisualFormat(format: "V:|[v0]|", views: sendButton)
//            containerView.backgroundColor = .gray
//            return containerView
//        }
//    }  
//
//    override var canBecomeFirstResponder: Bool{
//        return true
//    }
    
    
    
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
//        let date = String(describing: Date())
        let date = String(describing: Date().timeIntervalSince1970)

        let values: [String: Any] = ["sender": uid, "reciever": chosenUserUid, "date": date, "message": chatText]
        let messageRef = Database.database().reference().child("messages").child(randomId)
        let senderMessageRef = Database.database().reference().child("messagesRef").child(uid)
        let recieverMessageRef = Database.database().reference().child("messagesRef").child(chosenUserUid)
        messageRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                self.popupModel.createAlert(title: "Message not sent.", message: "Error when sending message")
            }
            senderMessageRef.updateChildValues([randomId:1])
            recieverMessageRef.updateChildValues([randomId:1])

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
                        DispatchQueue.main.async(execute: {
                            self.collectionView?.reloadData()
                        })
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
}
