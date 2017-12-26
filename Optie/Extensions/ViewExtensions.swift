//
//  ViewExtensions.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-05.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit

extension UIView {
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

