//
//  SummaryController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/16/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import SafariServices

class SummaryController: knStaticListController {
    private let ui = UI()
    var subtotal: Double = 0 { didSet {
        ui.subtotalLabel.text = "$\(subtotal)"
        totalAmount += subtotal
        }}
    private var fee: Double = 0
    private var totalAmount: Double = 0 { didSet {
        ui.totalLabel.text = "$\(totalAmount)"
        }}
    private var selectedCard: Card?
    private var actions = [Int: (() -> Void)?]()

    override func setupView() {
        addBackButton()
        super.setupView()
        title = "Checkout"

        view.addSubviews(views: tableView)
        tableView.fillSuperView()

        datasource = ui.setupView()

        ui.checkoutButton.addTarget(self, action: #selector(startCheckout))
        fetchData()

        actions = [
            1: showCardsList
        ]
    }

    @objc func startCheckout() {
        guard let card = selectedCard?.id else {
            showCardsList()
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


    override func fetchData() {
        stripeWrapper.getPaymentMethods(successAction: { [weak self] cards in
            self?.setSelectedCard(card: cards.first)
            }, failAction: nil)
    }

    func setSelectedCard(card: Card?) {
        guard let card = card else { return }
        selectedCard = card
        ui.cardLabel.text = card.number + " - " + (card.userName ?? "")
        ui.cardImageView.image = stripeWrapper.getCardImage(card: card)
    }

    override func didSelectRow(at indexPath: IndexPath) {
        guard let action = actions[indexPath.row] else { return }
        action?()
    }
}


extension SummaryController: CardListDelegate {
    func didSelectCard(card: Card) {
        ui.cardImageView.image = stripeWrapper.getCardImage(card: card)
        ui.cardLabel.text = card.number + " - " + (card.userName ?? "")
        selectedCard = card
        startCheckout()
        dismiss()
    }

    func showCardsList() {
        let controller = CardListController()
        controller.delegate = self
        present(wrap(controller))
    }
}


extension SummaryController: SFSafariViewControllerDelegate {
    func showReceipt(url: String) {
        guard let link = URL(string: url) else { return }
        hideNavBar(true)
        let controller = SFSafariViewController(url: link)
        controller.delegate = self
        push(controller)
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        popToRoot()
        guard let cartID = appSetting.cartID else { return }
        EmptyCartWorker(cartID: cartID, successAction: nil).execute()
    }
}

