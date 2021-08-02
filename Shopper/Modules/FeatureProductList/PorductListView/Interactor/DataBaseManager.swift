//
//  DataBaseManager.swift
//  Shopper
//
//  Created by Avinash on 31/07/21.
//

import RealmSwift
import Foundation

typealias CellModelResults = Results<ProductItemCellModel>

protocol DBManagerManaging {
    func increaseQuantity(for id: Int)
    func decreaseQuantity(for id: Int)
    func getProductCellModels(offset: Int) -> CellModelResults?
    func getCartCellModels() -> [ProductItemCellModel]
    func getBadgeCount() -> Int
    func saveProductList(repo: Repository)
    var bindResults: ((CellModelResults?) -> ())? { get set }
    var bindSingleUpdate: ((ProductItemCellModel, Int) -> ())? { get set }
    var resultsCount: Int { get }
}

final class DataBaseManager: DBManagerManaging {
    var realm: Realm!
    var cellModelResults: CellModelResults?
    var bindResults: ((CellModelResults?) -> ())?
    var bindSingleUpdate: ((ProductItemCellModel, Int) -> ())?

    var resultsCount: Int {
        cellModelResults?.count ?? 0
    }
    var curOffset: Int = 1
    
    init() {
        do {
            realm = try Realm()
            _ = getProductCellModels(offset: 0)
        } catch {
            print("Error for Realm \(error)")
        }
    }

    func getProductCellModels(offset: Int) -> CellModelResults? {
        guard offset != curOffset else {
            return offset == 0 ? cellModelResults : nil
        }
        curOffset = offset
        cellModelResults = realm.objects(ProductItemCellModel.self).filter("id < %@", offset + 10)
        return cellModelResults
    }
    
    func getCartCellModels() -> [ProductItemCellModel] {
        let allResults = realm.objects(ProductItemCellModel.self)
        
        let cartItems = allResults.filter { $0.isAddedToCart }
        
        let cartCellModels: [ProductItemCellModel] = cartItems.compactMap { ProductItemCellModel(value: $0) }
        return cartCellModels
    }
    
    func getBadgeCount() -> Int {
        let cartItems = getCartCellModels()
        let cartItemsCount = cartItems.reduce(0) { $0 + $1.cartQuantity }
        return cartItemsCount
    }
    
    func dataBaseUpdated() {
        cellModelResults = realm.objects(ProductItemCellModel.self).filter("id < %@", curOffset + 10)
        bindResults?(cellModelResults)
    }
    
    func productUpdated(product: ProductItemCellModel, id: Int) {
        bindSingleUpdate?(product, id)
    }
    
    func increaseQuantity(for id: Int) {
        if let product = cellModelResults?[id] {
            updateProduct(product: product, quantity: product.cartQuantity + 1)
        }
    }
    
    func decreaseQuantity(for id: Int) {
        if let product = cellModelResults?[id], product.cartQuantity > 0 {
            updateProduct(product: product, quantity: product.cartQuantity - 1)
        }
    }
    
    func updateProduct(product: ProductItemCellModel, quantity: Int) {
        do {
            try realm.write {
                product.cartQuantity = quantity
                realm.refresh()
                productUpdated(product: product, id: product.id)
            }
        } catch {
            print("Error saving Product: \(error)")
        }
    }
    
    func saveProductList(repo: Repository) {
        do {
            try realm.write {
                realm.delete(realm.objects(ProductItemCellModel.self))
                realm.add(repo)
                realm.refresh()
                dataBaseUpdated()
            }
        } catch {
            print("Error saving Repository: \(error)")
        }
    }
}
