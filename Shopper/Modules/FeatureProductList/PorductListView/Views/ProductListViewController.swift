//
//  ProductListViewController.swift
//  Shopper
//
//  Created by Avinash on 28/07/21.
//

import UIKit

protocol ProductListViewable: class {
    func updateList(items: CellModelResults?)
    func updateItem(item: ProductItemCellModel, index: Int)
    func showAlert(message: String)
}

private enum Constants {
    static let barButtonSize: CGFloat = 0
    static let badgeSize: CGFloat = 18
    static let cartCountKey = "cartCountKey"
}

public final class ProductListViewController: UIViewController {
    static let identifier = "ProductListVC"

    var presenter: ProductListPresentable!
    
    private(set) lazy var collectionView: UICollectionView = {
        let containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.refreshControl = self.refreshControl
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        containerView.addSubview(collectionView)
        
        addConstraints(containerView: containerView, collectionView: collectionView)
        
        return collectionView
    }()
    
    private(set) lazy var dataSource = ProductListDataSource(collectionView: collectionView, delegate: self)
    
    private(set) lazy var refreshControl = UIRefreshControl()
    private(set) lazy var activityIndicator = UIActivityIndicatorView(style: .large)

    private(set) lazy var badgeLabel: UILabel = {
        let badge = UILabel(frame: CGRect(x: Constants.badgeSize - 5, y: -(Constants.badgeSize - 9) / 2, width: Constants.badgeSize, height: Constants.badgeSize))
        badge.layer.cornerRadius = badge.bounds.size.height / 2
        badge.textAlignment = .center
        badge.layer.masksToBounds = true
        badge.textColor = .white
        badge.font = UIFont.boldSystemFont(ofSize: 10)
        badge.backgroundColor = .red
        return badge
    }()
    
    func addConstraints(containerView: UIView, collectionView: UICollectionView) {
        NSLayoutConstraint.activate(
            [
                containerView.topAnchor.constraint(equalTo: view.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
                collectionView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leftAnchor, constant: 10),
                collectionView.rightAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.rightAnchor, constant: -10)
            ]
        )
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "List"
        refreshControl.addTarget(self, action: #selector(fetchProducts), for: .valueChanged)
        addCartViewWithBadge()
        activityIndicator.center = view.center
        view.bringSubviewToFront(activityIndicator)
        getBadgeCount()
        getProductItems(offset: 0)
        fetchProducts()
    }
    
    private func addCartViewWithBadge() {
        navigationItem.setHidesBackButton(true, animated: true)
        /// Setting up Cart button with badge in NavigationBar
        let cartButton = UIButton(frame: CGRect(x: 0, y: 0, width: Constants.barButtonSize, height: Constants.barButtonSize))
        cartButton.addTarget(self, action: #selector(cartButtonAction), for: .touchUpInside)
        cartButton.setImage(UIImage(named: "CartIcon"), for: .normal)
        cartButton.addSubview(badgeLabel)
        cartButton.bringSubviewToFront(badgeLabel)
        view.bringSubviewToFront(badgeLabel)
        let rightBarButton = UIBarButtonItem(customView: cartButton)
        navigationItem.setRightBarButton(rightBarButton, animated: false)
    }
    
    private func getBadgeCount() {
        let badgeCount = presenter.getBadgeCount()
        updateCartBadge(count: badgeCount)
    }
    
    private func updateBadgeCount(count: Int) {
        dataSource.cartBadgeCount = count
        if count == 0 {
            DispatchQueue.main.async {
                self.badgeLabel.removeFromSuperview()
            }
        } else {
            DispatchQueue.main.async {
                self.badgeLabel.text = String(count)
                self.addCartViewWithBadge()
            }
        }
    }
    
    @objc private func fetchProducts() {
        let isRefresh = self.refreshControl.isRefreshing
        activityIndicator.startAnimating()
        presenter.fetchItems(isRefresh: isRefresh)
    }
    
    @objc private func cartButtonAction() {
        presenter.routeToCartView()
    }
}

extension ProductListViewController: ProductListViewable {
    func updateList(items: CellModelResults?) {
        dataSource.updateItems(newItems: items)
        getBadgeCount()
        stopLoadingActions()
    }
    
    func updateItem(item: ProductItemCellModel, index: Int) {
        dataSource.updateItem(newItem: item, index: index)
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.stopLoadingActions()
            Utils.showAlert(title: "Alert", message: message, for: self)
        }
    }
}

extension ProductListViewController: ProductListDataSourceDelegate {
    func getProductItems(offset: Int) {
        presenter.getItems(offset: offset)
    }
    
    func increaseItemQuantity(id: Int) {
        presenter.onIncreaseItemQuantity(id: id)
    }
    
    func decreaseItemQuantity(id: Int) {
        presenter.onDecreaseItemQuantity(id: id)
    }
    
    func stopLoadingActions() {
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            if self.activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func updateCartBadge(count: Int) {
        updateBadgeCount(count: count)
    }
}

