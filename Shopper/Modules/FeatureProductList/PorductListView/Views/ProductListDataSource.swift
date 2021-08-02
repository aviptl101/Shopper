//
//  ProductListDataSource.swift
//  Shopper
//
//  Created by Avinash on 29/07/21.
//

import UIKit
import RealmSwift

protocol ProductListDataSourceDelegate: AnyObject {
    func getProductItems(offset: Int)
    func increaseItemQuantity(id: Int)
    func decreaseItemQuantity(id: Int)
    func updateCartBadge(count: Int)
    func stopLoadingActions()
}

private enum Constants {
    static let collectionViewIterimItemSpacing: CGFloat = 10
    static let collectionViewIterimLineSpacing: CGFloat = 10
    static let cellLabelsInterimSpacing: CGFloat = 5
    static let cellEdgeInsets: CGFloat = 5
    static let maxItemsPerRow = 2
    static let labelCharacterSpacing: Double = 0.75
    static let fontSize: CGFloat = 10
    static let fontSizeLarge: CGFloat = 11
    static let edgeInsets: CGFloat = 2
    static let imageHeight: CGFloat = 150
    static let stepperHeight: CGFloat = 45
}

final class ProductListDataSource: NSObject {
    weak var delegate: ProductListDataSourceDelegate?
    var collectionView: UICollectionView
    private var items: CellModelResults? {
        didSet {
            reloadData()
        }
    }
    var itemsCount: Int {
        return items?.count ?? 0
    }
    var cartBadgeCount = 0
    
    private lazy var gridLayout: UICollectionViewFlowLayout = {
        let lineSpacing = Constants.collectionViewIterimLineSpacing
        let interItemSpacing = Constants.collectionViewIterimItemSpacing
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interItemSpacing
        layout.sectionInset = UIEdgeInsets(top: Constants.edgeInsets, left: Constants.edgeInsets, bottom: lineSpacing, right: Constants.edgeInsets)
        return layout
    }()
    
    var cellWidth: CGFloat {
        let viewWidth: CGFloat = collectionView.frame.size.width
        return (viewWidth - Constants.collectionViewIterimItemSpacing - (2 * Constants.edgeInsets)) / 2
    }
    private var rowCellHeight: CGFloat = 0
    private var isScrolling = false
    
    init(collectionView: UICollectionView, delegate: ProductListDataSourceDelegate? = nil) {
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupCollectionView()
    }
    
    func updateItems(newItems: CellModelResults?) {
        guard let items = newItems else { return }
        self.items = items
    }
    
    func updateItem(newItem: ProductItemCellModel, index: Int) {
        let path = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [path])
            self.updateCartBadge()
        }
    }
    
    // MARK: - Private
    
    private func setupCollectionView() {
        registerCells()
        collectionView.collectionViewLayout = gridLayout
    }
    
    private func registerCells() {
        collectionView.register(ProductItemCell.nib, forCellWithReuseIdentifier: ProductItemCell.identifier)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateCartBadge()
        }
    }
        
    private func updateCartBadge() {
        delegate?.updateCartBadge(count: self.cartBadgeCount)
        delegate?.stopLoadingActions()
    }
    
    private func getProductCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductItemCell.identifier,
            for: indexPath
        )
        guard let itemCell = cell as? ProductItemCell else { return cell }
        guard let item = items?[indexPath.item] else { return itemCell }
        itemCell.configure(cellModel: item)
        itemCell.increaseQuantity = { id in
            self.delegate?.increaseItemQuantity(id: id)
            self.cartBadgeCount += 1
        }
        itemCell.decreaseQuantity = { id in
            self.delegate?.decreaseItemQuantity(id: id)
            self.cartBadgeCount -= 1
        }
        return itemCell
    }
}

// MARK: - CollectionView DataSource Methods

extension ProductListDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /// While scrolling if reached to end of collectionView, Then fetching next page items, offset = ItemsCount
        if self.isScrolling && indexPath.item >= self.itemsCount - 1 {
            self.delegate?.getProductItems(offset: self.itemsCount)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getProductCell(at: indexPath)
    }
}

extension ProductListDataSource: UICollectionViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
    }
}

extension ProductListDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = cellWidth
        let itemHeight = indexPath.row % 2 == 0 ? findCellHeight(for: indexPath) : rowCellHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func findCellHeight(for indexPath: IndexPath) -> CGFloat {
        rowCellHeight = 0
        for i in 0...1 {
            guard let item = items?[safe: indexPath.row + i] else { break }
            
            let  cellHeight = calculateCellHeight(for: item)
            if cellHeight > rowCellHeight {
                rowCellHeight = cellHeight
            }
            if indexPath.row + i == (itemsCount) - 1 {
                break
            }
        }
        return rowCellHeight
    }
     
    func calculateCellHeight(for model: ProductItemCellModel) -> CGFloat {
        let width = cellWidth - (2 * Constants.cellEdgeInsets)
        let titleHeight = model.name?.height(constraintedWidth: width, font: UIFont.title) ?? 0
        let descriptionHeight = model.itemDescription?.height(constraintedWidth: width, font: UIFont.description) ?? 0
        let priceHeight = model.price?.height(constraintedWidth: width, font: UIFont.price) ?? 0
        return (titleHeight + descriptionHeight + priceHeight + Constants.stepperHeight + (5 * Constants.cellLabelsInterimSpacing) + Constants.cellEdgeInsets + Constants.imageHeight)
    }
}
