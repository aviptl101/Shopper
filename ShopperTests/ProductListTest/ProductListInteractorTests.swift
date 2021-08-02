//
//  ProductListInteractorTests.swift
//  ShopperTests
//
//  Created by Avinash on 01/08/21.
//

import XCTest
@testable import Shopper

class ProductListInteractorTests: XCTestCase {
    private var interactor: ProductListInteractor!
    private var mockDBManager: MockDBManager!

    override func setUpWithError() throws {
        super.setUp()
        interactor = ProductListInteractor()
        mockDBManager = MockDBManager() 
        interactor.dbManager = mockDBManager
    }

    override func tearDownWithError() throws {
        interactor = nil
        mockDBManager = nil
    }
    
    func testFetchProductList() {
        // Arrange
        let expectation = XCTestExpectation(description: "fetch")
        interactor.bindCellModels = { (cellModels) in
            expectation.fulfill()
            XCTAssertNotNil(cellModels)
        }
        
        // Act
        interactor.fetchProductList(isRefresh: true)
    }
    
    func testIncreaseProductQuantity() {
        // Arrange
        let id = 0
        
        // Act
        interactor.increaseProductQuantity(id: id)
        
        // Assert
        guard case .increaseQuantity = mockDBManager.calledMethods.first else {
            XCTFail("increaseQuantity not called")
            return
        }
    }
    
    func testDecreaseProductQuantity() {
        // Arrange
        let id = 0
        
        // Act
        interactor.decreaseProductQuantity(id: id)
        
        // Assert
        guard case .decreaseQuantity = mockDBManager.calledMethods.first else {
            XCTFail("decreaseQuantity not called")
            return
        }
    }
    
    func testGetCartProducts() {
        // Act
        _ = interactor.getCartProducts()
        
        // Assert
        guard case .getCartCellModels = mockDBManager.calledMethods.first else {
            XCTFail("getCartCellModels not called")
            return
        }
    }
    
    func testGetBadgeCount() {
        // Act
        _ = interactor.getBadgeCount()
        
        // Assert
        guard case .getBadgeCount = mockDBManager.calledMethods.first else {
            XCTFail("getCartCellModels not called")
            return
        }
    }
    
    func testCreateProductCellModels() {
        // Arrange
        let model = ProductModel(name: "Name", id: "1", price: "5", image: "image", description: "Desc")
        let models: [ProductModel] = [model]
        
        // Act
        interactor.createProductCellModels(from: models)
        
        // Assert
        guard case .saveProductList = mockDBManager.calledMethods.first else {
            XCTFail("getCartCellModels not called")
            return
        }
    }
}
