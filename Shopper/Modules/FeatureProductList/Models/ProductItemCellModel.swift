//
//  ProductItemCellModel.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import Foundation
import RealmSwift

public class ProductItemCellModel: Object {
    @objc dynamic var name: String?
    @objc dynamic var id: Int = 0
    @objc dynamic var itemDescription: String?
    @objc dynamic var price: String?
    @objc dynamic var imageUrl: String?
    @objc dynamic var cartQuantity = 0
    var isAddedToCart: Bool {
        return cartQuantity > 0 ? true : false
    }

    convenience init(model: ProductModel?) {
        self.init()
        self.name = model?.name ?? ""
        let pId = Int(model?.id ?? "") ?? 0
        self.id = pId - 1
        self.itemDescription = model?.description ?? ""
        self.imageUrl = model?.image ?? ""
        if let p = model?.price {
            self.price = "$\(p)"
        } else {
            self.price = "$0"
        }
    }
}

class Repository: Object {
  dynamic var id: String = ""
  let products = List<ProductItemCellModel>()
}
