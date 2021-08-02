//
//  ProductListPresenter.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import Foundation

protocol ProductListPresentable {
    func fetchItems(isRefresh: Bool)
    func getItems(offset: Int)
    func getBadgeCount() -> Int
    func onIncreaseItemQuantity(id: Int)
    func onDecreaseItemQuantity(id: Int)
    func routeToCartView()
}

final class ProductListPresenter {
    weak var view: ProductListViewable!
    private let router: ProductListRouter
    let interactor: ProductListInteractor
    
    init(view: ProductListViewable?, router: ProductListRouter, interactor: ProductListInteractor) {
        self.router = router
        self.view = view
        self.interactor = interactor
        setupBinding()
    }
    
    private func setupBinding() {
        interactor.bindCellModels = { [weak self] (cellModels) in
            self?.view.updateList(items: cellModels)
        }
        interactor.bindSingleUpdate = { [weak self] (cellModel, index) in
            self?.view.updateItem(item: cellModel, index: index)
        }
        interactor.bindError = { [weak self] (errorMsg) in
            self?.view.showAlert(message: errorMsg)
        }
    }
}

extension ProductListPresenter: ProductListPresentable {
    func fetchItems(isRefresh: Bool) {
        interactor.fetchProductList(isRefresh: isRefresh)
    }
    
    func getItems(offset: Int) {
        interactor.getProductList(offset: offset)
    }
    
    func getBadgeCount() -> Int {
        return interactor.getBadgeCount()
    }
    
    func onIncreaseItemQuantity(id: Int) {
        interactor.increaseProductQuantity(id: id)
    }
    
    func onDecreaseItemQuantity(id: Int) {
        interactor.decreaseProductQuantity(id: id)
    }
    
    func routeToCartView() {
        let cartItems = interactor.getCartProducts()
        router.navigateToCartView(cartItems: cartItems)
    }
}
