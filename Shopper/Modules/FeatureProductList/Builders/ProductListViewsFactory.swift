//
//  ProductListViewsFactory.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import UIKit

public class ProductListViewsFactory: NSObject {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func buildProductListsVC() -> ProductListViewController? {
        let viewController = storyboard.instantiateViewController(identifier: ProductListViewController.identifier) as? ProductListViewController
        return viewController
    }
    
    func buildCartVC() -> CartViewController? {
        let viewController = storyboard.instantiateViewController(identifier: CartViewController.identifier) as? CartViewController
        return viewController
    }
}

