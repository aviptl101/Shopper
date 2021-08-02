//
//  MockDBManager.swift
//  ShopperTests
//
//  Created by Avinash on 01/08/21.
//

import Foundation
@testable import Shopper

final class MockDBManager: DBManagerManaging {
    enum MethodHandler {
        case increaseQuantity
        case decreaseQuantity
        case getCartCellModels
        case getBadgeCount
        case saveProductList
    }

    private(set) var calledMethods: [MethodHandler] = []
    
    func increaseQuantity(for id: Int) {
        calledMethods.append(.increaseQuantity)
    }
    
    func decreaseQuantity(for id: Int) {
        calledMethods.append(.decreaseQuantity)
    }
    
    func getProductCellModels(offset: Int) -> CellModelResults? {
        return nil
    }
    
    func getCartCellModels() -> [ProductItemCellModel] {
        calledMethods.append(.getCartCellModels)
        return []
    }
    
    func getBadgeCount() -> Int {
        calledMethods.append(.getBadgeCount)
        return 0
    }
    
    func saveProductList(repo: Repository) {
        calledMethods.append(.saveProductList)
    }
    
    var bindResults: ((CellModelResults?) -> ())?
    
    var bindSingleUpdate: ((ProductItemCellModel, Int) -> ())?
    
    var resultsCount: Int = 0
}
