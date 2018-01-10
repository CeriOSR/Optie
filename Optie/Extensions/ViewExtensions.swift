//
//  ViewExtensions.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-05.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit

extension UIView {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
    
    func anchors(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, width: CGFloat = 0, height: CGFloat = 0) {
        guard let top = top, let bottom = bottom, let left = left, let right = right else {return}
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func pinToEdges(view: UIView) {
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func addConstraintsWithVisualFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
}

private let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadEventImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        } else {
            let url = NSURL(string: urlString)
            URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
                if error != nil {
                    let err = error! as NSError
                    print(err)
                    return
                }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        let jpgImage = UIImageJPEGRepresentation(downloadedImage, 0.2)
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    }
                }
            }).resume()
        }
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

