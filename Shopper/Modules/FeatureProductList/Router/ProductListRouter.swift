//
//  ProductListRouter.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import UIKit

public protocol ProductListRoutingHandling {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool)
    func presentViewController(_ viewController: UIViewController, animated: Bool)
    func popViewControllers(viewsToPop: Int)
}

public class ProductListRouter {
    public let routingHandler: ProductListRoutingHandling
    public let builder: ProductListBuilder
    
    public init(routingHandler: ProductListRoutingHandling, builder: ProductListBuilder) {
        self.routingHandler = routingHandler
        self.builder = builder
    }
    
    public func navigateToCartView(cartItems: [ProductItemCellModel]) {
        guard let viewController = builder.createCartViewModule(router: self, cartItems: cartItems) else { return }
        routingHandler.pushViewController(viewController, animated: true)
    }
}
