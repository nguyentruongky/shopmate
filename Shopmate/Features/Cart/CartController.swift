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
    }
    
    func showAddCard() {
        let controller = AddCardController()
        controller.delegate = self
        present(wrap(controller))
    }
    
    @objc func startCheckout() {
        guard let card = selectedCardId else {
            showAddCard()
            return
        }
        ui.checkoutButton.setProcess(visible: true)
        stripeWrapper.charge(amountInSmallestUnit: totalAmount * 100,
                             currency: "USD",
                             cardToken: card,
                             transactionId: appSetting.cartID ?? "",
                             successAction: { [weak self] message in
                                self?.showReceipt(url: message)
                                self?.ui.checkoutButton.setProcess(visible: false)
        }, failAction: { [weak self] err in
            self?.ui.checkoutButton.setProcess(visible: false)
            MessageHub.showError(err.localizedDescription)
        })
    }

    func showReceipt(url: String) {
        guard let link = URL(string: url) else { return }
        hideNavBar(true)
        let controller = SFSafariViewController(url: link)
        controller.delegate = self
        push(controller)
    }

    var totalAmount: Double = 0
    var selectedCardId: String?
    
    override func fetchData() {
        GetCartItemsWorker(successAction: didGetCart).execute()
        GetTotalAmountWorker(successAction: { [weak self] amount in
            self?.totalAmount = amount
            self?.ui.checkoutButton.setTitle("Checkout $\(amount)")
        
            }, failAction: nil).execute()
        stripeWrapper.getPaymentMethods(successAction: { [weak self] cards in
            self?.selectedCardId = cards.first?.id
            }, failAction: nil)
    }
    
    func didGetCart(items: [CartItem]) {
        datasource = items
        title = "Cart (\(items.count))"
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
    }

    func updateTotal() {
        GetTotalAmountWorker(successAction: { [weak self] amount in
            self?.totalAmount = amount
            self?.ui.checkoutButton.setTitle("Checkout $\(amount)")

            }, failAction: nil).execute()
    }
}


extension CartController: AddCardDelegate {
    func didAddCard(_ card: String) {
        selectedCardId = card
        startCheckout()
    }
}

extension CartController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        popToRoot()
        guard let cartID = appSetting.cartID else { return }
        EmptyCartWorker(cartID: cartID, successAction: nil).execute()
    }
}
