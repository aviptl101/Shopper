//
//  ProductListVCTests.swift
//  ShopperTests
//
//  Created by Avinash on 01/08/21.
//

import XCTest
@testable import Shopper

class ProductListVCTests: XCTestCase {
    private var view: ProductListViewController!
    private var mockPresenter: MockProductListPresenter!

    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        view = storyboard.instantiateViewController(withIdentifier: ProductListViewController.identifier) as? ProductListViewController
        mockPresenter = MockProductListPresenter()
        view.presenter = mockPresenter
    }

    override func tearDownWithError() throws {
        view = nil
        mockPresenter = nil
    }
    
    func testGetProductItems() {
        // Act
        view.getProductItems(offset: 0)
        
        // Assert
        guard case .getItems = mockPresenter.calledMethods.first else {
            XCTFail("GetItems not called")
            return
        }
    }
    
    func testIncreaseItemQuantity() {
        // Arrange
        let id = 0
        
        // Act
        view.increaseItemQuantity(id: id)
        
        // Assert
        guard case .onIncreaseItemQuantity(id: id) = mockPresenter.calledMethods.first else {
            XCTFail("onIncreaseItemQuantity not called")
            return
        }
    }
    
    func testDecreaseItemQuantity() {
        // Arrange
        let id = 0
        
        // Act
        view.decreaseItemQuantity(id: id)
        
        // Assert
        guard case .onDecreaseItemQuantity(id: id) = mockPresenter.calledMethods.first else {
            XCTFail("onDecreaseItemQuantity not called")
            return
        }
    }
}
