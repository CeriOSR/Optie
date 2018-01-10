//
//  NewMessagesCollectionViewController.swift
//  Optie
//
//  Created by Rey Cerio on 2018-01-04.
//  Copyright © 2018 Rey Cerio. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewMessagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let containerView: UIView = {
        let cv = UIView()
//        cv.backgroundColor = UIColor(r: 13, g: 31, b: 61)
        cv.backgroundColor = .red
        return cv
    }()
    
    let chatTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "message..."
        return tf
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "SEND") , for: .normal)
        return button
    }()
    
    func setupView() {
//        let autoLayouts = [NSla]
        collectionView?.backgroundColor = self.view.tintColor
        let bottom = view.safeAreaLayoutGuide.bottomAnchor
        let top = view.safeAreaLayoutGuide.topAnchor
        let right = view.safeAreaLayoutGuide.rightAnchor
        let left = view.safeAreaLayoutGuide.leftAnchor
        view.addSubview(containerView)
        containerView.addSubview(chatTextField)
        containerView.addSubview(sendButton)
        
        view.addConstraintsWithVisualFormat(format: "H:|[v0]|", views: containerView)
        view.addConstraintsWithVisualFormat(format: "V:[v0(50)]|", views: containerView)
        
        containerView.addConstraintsWithVisualFormat(format: "H:|-2-[v0]-4-[v1(60)]-2-|", views: chatTextField, sendButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupView()
        self.collectionView!.register(NewMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    override func viewSafeAreaInsetsDidChange() {
        setupView()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewMessageCell
    
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }

}
