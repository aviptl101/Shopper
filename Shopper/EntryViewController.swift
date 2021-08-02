//
//  EntryViewController.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import UIKit

class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProductListView()
    }
    
    private func showProductListView() {
        let viewsFactory = ProductListViewsFactory()
        let builder = ProductListBuilder(viewFactory: viewsFactory)
        let router = ProductListRouter(routingHandler: self, builder: builder)

        guard let productListVC = builder.createProductListModule(router: router) else { return }
        navigationController?.pushViewController(productListVC, animated: true)
    }
}

extension EntryViewController: ProductListRoutingHandling {
    
    func presentViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.present(viewController, animated: animated, completion: nil)
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popViewControllers(viewsToPop: Int) {
        navigationController?.popViewControllers(viewsToPop: viewsToPop)
    }
}

extension UINavigationController {
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
}
