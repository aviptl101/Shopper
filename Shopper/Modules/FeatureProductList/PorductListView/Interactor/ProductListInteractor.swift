//
//  ProductListInteractor.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import Foundation

protocol ProductListInteracting {
    func fetchProductList(isRefresh: Bool)
    func getProductList(offset: Int)
    func increaseProductQuantity(id: Int)
    func decreaseProductQuantity(id: Int)
    func getCartProducts() -> [ProductItemCellModel]
    func getBadgeCount() -> Int
}

final class ProductListInteractor: ProductListInteracting {
    var dbManager: DBManagerManaging = DataBaseManager()
    var productList: [ProductModel] = [] {
        didSet {
            createProductCellModels(from: productList)
        }
    }
    var bindCellModels: ((CellModelResults?) -> ())?
    var bindSingleUpdate: ((ProductItemCellModel, Int) -> ())?
    var bindError: ((String) -> ())?

    init() {
        setBindingWithDBManager()
    }
    
    private func setBindingWithDBManager() {
        dbManager.bindResults = { (results) in
            self.bindCellModels?(results)
        }
        dbManager.bindSingleUpdate = { (cellModel, id) in
            self.bindSingleUpdate?(cellModel, id)
        }
    }
    
    func fetchProductList(isRefresh: Bool) {
        if !isRefresh {
            guard dbManager.resultsCount == 0 else { return }
        }
        
        let parameters = RequestEndPoint.getProducts
        RequestManager.fetchProducts(endPoint: parameters) { [weak self] (result) in
            switch result {
            case .success(let products):
                self?.productList = products
            case .failure(let error):
                self?.bindError?(error.errorMessage)
            }
        }
    }
    
    func getProductList(offset: Int) {
        guard let results = dbManager.getProductCellModels(offset: offset) else { return }
        bindCellModels?(results)
    }
    
    func increaseProductQuantity(id: Int) {
        dbManager.increaseQuantity(for: id)
    }
    
    func decreaseProductQuantity(id: Int) {
        dbManager.decreaseQuantity(for: id)
    }
    
    func getCartProducts() -> [ProductItemCellModel] {
        return dbManager.getCartCellModels()
    }
    
    func getBadgeCount() -> Int {
        return dbManager.getBadgeCount()
    }
    
    func createProductCellModels(from items: [ProductModel]) {
        let repo = Repository()
        repo.id = "products"
        
        for item in items {
            let cellModel = ProductItemCellModel(model: item)
            repo.products.append(cellModel)
        }
        dbManager.saveProductList(repo: repo)
    }
}
