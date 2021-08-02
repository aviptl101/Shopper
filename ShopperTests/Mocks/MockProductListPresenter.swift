//
//  MockProductListPresenter.swift
//  ShopperTests
//
//  Created by Avinash on 01/08/21.
//

import Foundation
@testable import Shopper

final class MockProductListPresenter: ProductListPresentable {
    enum MethodHandler {
        case fetchItems(isRefresh: Bool)
        case getItems(offset: Int)
        case getBadgeCount
        case onIncreaseItemQuantity(id: Int)
        case onDecreaseItemQuantity(id: Int)
        case routeToCartView
    }

    private(set) var calledMethods: [MethodHandler] = []
    
    func fetchItems(isRefresh: Bool) {
        calledMethods.append(.fetchItems(isRefresh: isRefresh))
    }
    
    func getItems(offset: Int) {
        calledMethods.append(.getItems(offset: offset))
    }
    
    func getBadgeCount() -> Int {
        calledMethods.append(.getBadgeCount)
        return 1
    }
    
    func onIncreaseItemQuantity(id: Int) {
        calledMethods.append(.onIncreaseItemQuantity(id: id))
    }
    
    func onDecreaseItemQuantity(id: Int) {
        calledMethods.append(.onDecreaseItemQuantity(id: id))
    }
    
    func routeToCartView() {
        calledMethods.append(.routeToCartView)
    }

}
