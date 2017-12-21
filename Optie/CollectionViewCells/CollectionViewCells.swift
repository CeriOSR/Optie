//
//  CollectionViewCells.swift
//  Optie
//
//  Created by Rey Cerio on 2017-12-17.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit

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
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Wednesday:"
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dayCell, for: indexPath) as! DayCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 4, 0, 4)
    }
}

class DayCell: BaseCell {
    
    override func setupViews() {
        backgroundColor = .black
    }
    
}
