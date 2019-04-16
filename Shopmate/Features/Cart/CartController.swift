//
//  CartController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import SafariServices

class CartController: knListController<CartCell, CartItem> {
    let ui = UI()
    let stateView = knStateView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar(false)
    }
    
    override func setupView() {
        addBackButton()
        rowHeight = 160
        super.setupView()
        view.addSubviews(views: tableView, ui.checkoutButton)
        tableView.horizontalSuperview()
        tableView.topSuperView()
        tableView.verticalSpacingDown(toView: ui.checkoutButton, space: gap)
        
        ui.checkoutButton.horizontalSuperview(space: gap)
        ui.checkoutButton.bottomSuperView(space: -gap * 2)
        
        ui.checkoutButton.addTarget(self, action: #selector(startCheckout))
        fetchData()

        stateView.setStateContent(state: .empty, imageName: "empty_cart", title: "No items yet", content: "Start shopping and your items will be here")
    }

    @objc func startCheckout() {
        let controller = SummaryController()
        controller.subtotal = totalAmount
        push(controller)
    }

    var totalAmount: Double = 0
    
    override func fetchData() {
        stateView.show(state: .loading, in: view)
        GetCartItemsWorker(successAction: didGetCart).execute()
        GetTotalAmountWorker(successAction: { [weak self] amount in
            self?.totalAmount = amount
            if amount == 0 {
                self?.ui.checkoutButton.setTitle("Checkout")
                self?.ui.checkoutButton.isEnabled = false
            } else {
                self?.ui.checkoutButton.setTitle("Checkout $\(amount)")
                self?.ui.checkoutButton.isEnabled = true
            }
            }, failAction: nil).execute()
    }
    
    func didGetCart(items: [CartItem]) {
        datasource = items
        if items.isEmpty {
            stateView.state = .empty
        } else {
            stateView.state = .success
        }
        updateUI()
    }
    
    override func getCell(at index: IndexPath) -> UITableViewCell {
        let cell = super.getCell(at: index) as! CartCell
        cell.cartController = self
        return cell
    }
    
    func deleteItem(item: CartItem) {
        guard let index = datasource.firstIndex(where:
            { return item.itemID == $0.itemID }) else { return }
        datasource.remove(at: Int(index))
        updateUI()
    }

    func updateUI() {
        if datasource.isEmpty {
            title = "Cart"
            ui.checkoutButton.setTitle("Checkout")
            ui.checkoutButton.isEnabled = false
        } else {
            title = "Cart (\(datasource.count))"
            ui.checkoutButton.setTitle("Checkout $\(totalAmount)")
            ui.checkoutButton.isEnabled = true
        }
    }

    func updateTotal() {
        var total: Double = 0
        for i in 0 ..< datasource.count {
            let indexPath = IndexPath(row: i, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? CartCell else { continue }
            total += cell.getTotal()
        }
        ui.checkoutButton.setTitle("Checkout $\(total)")
        totalAmount = total
    }
}

