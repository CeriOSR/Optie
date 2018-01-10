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

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = self.view.tintColor
        
        self.collectionView!.register(MessageListCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 7
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageListCell
    
        // Configure the cell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 10, 0, -50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let newMessageController = NewMessagesCollectionViewController(collectionViewLayout: layout)
        let navNewMessageController = UINavigationController(rootViewController: newMessageController)
        present(navNewMessageController, animated: true) {
            //PASS INDEXPATH USER DATA HERE
        }
    }

}
