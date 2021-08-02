//
//  CartViewPresenter.swift
//  Shopper
//
//  Created by Avinash on 01/08/21.
//

import Foundation

protocol CartViewPresentable {
    func displayCartItems()
}

final class CartViewPresenter {
    weak var view: CartViewable!
    private let router: ProductListRouter
    private let interactor: CartViewInteractor
    
    init(view: CartViewable?, router: ProductListRouter, interactor: CartViewInteractor) {
        self.router = router
        self.view = view
        self.interactor = interactor
    }
    
    private func addCartItems(items: [ProductItemCellModel]) {
        view.addCartItems(items: items)
    }
}

extension CartViewPresenter: CartViewPresentable {
    func displayCartItems() {
        guard let cartItems = interactor.cartItems else { return }
        addCartItems(items: cartItems)
    }
}
