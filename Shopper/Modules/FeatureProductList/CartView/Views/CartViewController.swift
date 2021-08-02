//
//  CartViewController.swift
//  Shopper
//
//  Created by Avinash on 01/08/21.
//

import UIKit

protocol CartViewable: class {
    func addCartItems(items: [ProductItemCellModel])
}

public final class CartViewController: UIViewController {
    static let identifier = "CartVC"
    
    private(set) lazy var tableView: UITableView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        view.addSubview(container)

        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = .clear
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        container.addSubview(tableView)
        addConstraints(containerView: container, tableView: tableView)
        return tableView
    }()
    
    private(set) lazy var dataSource = CartTableViewDataSource(tableView: tableView, delegate: self)
    var presenter: CartViewPresenter!

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cart"
        displayItems()
    }
    
    func addConstraints(containerView: UIView, tableView: UITableView) {
        NSLayoutConstraint.activate(
            [
                containerView.topAnchor.constraint(equalTo: view.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                
                tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10)
            ]
        )
    }
}

extension CartViewController: CartViewable {
    func addCartItems(items: [ProductItemCellModel]) {
        guard items.count > 0 else { return }
        dataSource.updateItems(items: items)
    }
}

extension CartViewController: CartTableViewDataSourceDelegate {
    func displayItems() {
        presenter.displayCartItems()
    }
}
