//
//  UsersChatController.swift
//  Optie
//
//  Created by Rey Cerio on 2018-01-03.
//  Copyright © 2018 Rey Cerio. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class MessageListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var timer = Timer()
    var messageDictionary = [String: Message]()
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = self.view.tintColor
        self.collectionView!.register(MessageListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchMessages()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageListCell
        let message = messages[indexPath.item]
        cell.message = message
        cell.messageLabel.text = message.message
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 6, 0, 6)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let newMessageController = NewMessagesCollectionViewController(collectionViewLayout: layout)
        let navNewMessageController = UINavigationController(rootViewController: newMessageController)
        
        present(navNewMessageController, animated: true) {
            //PASS INDEXPATH USER DATA HERE
            
        }
    }
    
    func fetchMessages() {
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
                self.messages.append(message)
                guard let reciever = message.reciever else {return}
                self.messageDictionary[reciever] = message
                self.messages = Array(self.messageDictionary.values)
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


}
