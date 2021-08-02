//
//  ProductItemCell.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import UIKit

class ProductItemCell: UICollectionViewCell {
    static let identifier = "ProductItemCell"
    static let nib = UINib.init(nibName: "ProductItemCell", bundle: Bundle.main)
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var increaseBtnContainer: UIView!
    @IBOutlet weak var decreaseBtnContainer: UIView!
    var id = 0
    var increaseQuantity: ((Int) -> ())?
    var decreaseQuantity: ((Int) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //animateImageView()
    }
    
    func configure(cellModel: ProductItemCellModel) {
        DispatchQueue.main.async {
            self.id = cellModel.id
            self.nameLbl.text = cellModel.name ?? ""
            self.nameLbl.font = UIFont.title
            self.descriptionLbl.text = cellModel.itemDescription ?? ""
            self.descriptionLbl.font = UIFont.description
            self.priceLbl.text = cellModel.price ?? ""
            self.priceLbl.font = UIFont.price
            
            if cellModel.isAddedToCart {
                self.quantityLbl.text = String(cellModel.cartQuantity)
                self.addToCartBtn.isHidden = true
                self.quantityLbl.isHidden = false
                self.increaseBtnContainer.isHidden = false
                self.decreaseBtnContainer.isHidden = false
            } else {
                self.addToCartBtn.isHidden = false
                self.quantityLbl.isHidden = true
                self.increaseBtnContainer.isHidden = true
                self.decreaseBtnContainer.isHidden = true
            }
            self.productImageView.sd_setImage(with: URL(string: cellModel.imageUrl ?? ""), placeholderImage: UIImage(systemName: "person.circle"))
        }
    }
    
    override func prepareForReuse() {
        DispatchQueue.main.async {
            self.nameLbl.text = ""
            self.descriptionLbl.text = ""
            self.priceLbl.text = ""
            self.id = 0
            self.quantityLbl.text = "1"
            self.addToCartBtn.isHidden = false
            self.quantityLbl.isHidden = true
            self.increaseBtnContainer.isHidden = true
            self.decreaseBtnContainer.isHidden = true
        }
    }
    
    @IBAction func addToCartAction() {
        increaseQuantity?(id)
    }
    
    @IBAction func increaseQuantityAction() {
        increaseQuantity?(id)
    }
    
    @IBAction func decreaseQuantityAction() {
        decreaseQuantity?(id)
    }
}
