//
//  Utils.swift
//  Shopper
//
//  Created by Avinash on 01/08/21.
//

import UIKit

class Utils {
    /// Common method to show alert from any ViewController
    static func showAlert(title: String = "Alert", message: String = "Server Error", for view: UIViewController?, completion: (() -> Void)? = nil) {
        guard let view = view else { return }
        
        let messageCapitalized = (message != "" && !message.isEmpty) ? message.capitalized : "Server Error"
        
        let alert = UIAlertController(title: title, message: messageCapitalized, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            completion?()
        }))
        
        view.present(alert, animated: true, completion: nil)
    }
}
