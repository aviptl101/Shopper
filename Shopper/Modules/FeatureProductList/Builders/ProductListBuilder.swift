//
//  ProductListBuilder.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import Foundation

public final class ProductListBuilder {
    let viewFactory: ProductListViewsFactory

    init(viewFactory: ProductListViewsFactory) {
        self.viewFactory = viewFactory
    }
    
    public func createProductListModule(router: ProductListRouter) -> ProductListViewController? {
        let productListVC = viewFactory.buildProductListsVC()
        let interactor = ProductListInteractor()
        let presenter = ProductListPresenter(view: productListVC, router: router, interactor: interactor)
        productListVC?.presenter = presenter
        return productListVC
    }
    
    public func createCartViewModule(router: ProductListRouter, cartItems: [ProductItemCellModel]) -> CartViewController? {
        let cartVC = viewFactory.buildCartVC()
        let interactor = CartViewInteractor()
        interactor.cartItems = cartItems
        let presenter = CartViewPresenter(view: cartVC, router: router, interactor: interactor)
        cartVC?.presenter = presenter
        return cartVC
    }
}
