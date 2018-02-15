//
//  PopupsModel.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-12.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit

class PopupViewModel: UIAlertController {
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            return
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

