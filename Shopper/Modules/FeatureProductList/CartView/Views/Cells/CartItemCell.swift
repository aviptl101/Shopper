//
//  CartItemCell.swift
//  Shopper
//
//  Created by Avinash on 01/08/21.
//

import UIKit
import SDWebImage

class CartItemCell: UITableViewCell {
    static let identifier = "CartItemCell"
    static let nib = UINib.init(nibName: "CartItemCell", bundle: Bundle.main)
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        productImageView.layer.cornerRadius = 5
    }
    
    func configure(cellModel: ProductItemCellModel) {
        DispatchQueue.main.async {
            self.productImageView.sd_setImage(with: URL(string: cellModel.imageUrl ?? ""), placeholderImage: UIImage(systemName: "person.circle"))
            self.nameLbl.text = "\(cellModel.name ?? "") x \(cellModel.cartQuantity)"
        }
    }
}
