//
//  Extensions.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import UIKit

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIFont {
    static let title = UIFont.boldSystemFont(ofSize: 15)
    static let description = UIFont.systemFont(ofSize: 12)
    static let price = UIFont.systemFont(ofSize: 18, weight: .heavy)
}
