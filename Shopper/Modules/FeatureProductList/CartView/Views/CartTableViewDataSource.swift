//
//  CartTableViewDataSource.swift
//  Shopper
//
//  Created by Avinash on 01/08/21.
//

import UIKit

protocol CartTableViewDataSourceDelegate: AnyObject {
    func displayItems()
}

final class CartTableViewDataSource: NSObject {
    weak var delegate: CartTableViewDataSourceDelegate?
    var tableView: UITableView
    private var cartItems: [ProductItemCellModel]? {
        didSet {
            reloadData()
        }
    }
    var itemsCount: Int {
        return cartItems?.count ?? 0
    }
    
    init(tableView: UITableView, delegate: CartTableViewDataSourceDelegate? = nil) {
        self.tableView = tableView
        self.delegate = delegate
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(CartItemCell.nib, forCellReuseIdentifier: CartItemCell.identifier)
    }
    
    func updateItems(items: [ProductItemCellModel]) {
        self.cartItems = items
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func getItemCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemCell.identifier,
            for: indexPath
        )
        guard let itemCell = cell as? CartItemCell else { return cell }
        guard let item = cartItems?[indexPath.section] else { return itemCell }
        
        itemCell.configure(cellModel: item)
        return itemCell
    }
}

// MARK: TableViewDataSource Methods

extension CartTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getItemCell(at: indexPath)
    }
}

// MARK: - TableViewDelegate Methods

extension CartTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.sizeToFit()
        headerView.backgroundColor = .clear
        return headerView
    }
            
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
