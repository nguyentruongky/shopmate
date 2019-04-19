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
    let ui = UI()
    private var subtotal: Double = 0
    func setSubtotal(amount: Double) {
        subtotal = amount
        ui.subtotalLabel.text = "$\(amount)"
        updateTotal()
    }
    var fee: Double = 0
    var totalAmount: Double = 0

    func updateTotal() {
        totalAmount = subtotal + fee
        ui.totalLabel.text = "$\(totalAmount)"
    }

    private var selectedCard: Card?
    private var actions = [Int: (() -> Void)?]()
    lazy var output = Interactor(controller: self)
    var shippingAddress: Address?
    var shippingMethods = [ShippingMethod]()
    var selectedShippingMethods: ShippingMethod?

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
            0: showAddress,
            1: showCardsList
        ]

        ui.cardLabel.text = "No card added"
        ui.cardImageView.image = stripeWrapper.getCardImage(brand: .unknown)

        ui.pickShippingButton.addTarget(self, action: #selector(showShippingMethodList))
    }

    @objc func showShippingMethodList() {
        ui.picker.show(in: self)
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
        output.getPaymentMethods()
        output.getShippingAddress()
    }

    override func didSelectRow(at indexPath: IndexPath) {
        guard let action = actions[indexPath.row] else { return }
        action?()
    }
}


extension SummaryController: knPickerViewDelegate {
    func didSelectText(_ text: String) {
        guard let index = shippingMethods.firstIndex(where: { $0.shippingType == text }) else { return }
        didSelectShippingMethod(method: shippingMethods[Int(index)])
    }

    func didSelectShippingMethod(method: ShippingMethod) {
        selectedShippingMethods = method
        ui.shippingMethodLabel.text = method.shippingType
        if let feeText = method.shippingCost?.remove("$"), let fee = Double(feeText) {
            ui.feeLabel.text = "$" + feeText
            self.fee = fee
            updateTotal()
        }
    }
}

extension SummaryController {
    func showAddress() {
        let controller = AddressController()
        controller.delegate = output
        present(wrap(controller))
    }
}

extension SummaryController: CardListDelegate {
    func setSelectedCard(card: Card?) {
        guard let card = card else { return }
        selectedCard = card
        ui.cardLabel.text = card.number + " - " + (card.userName ?? "")
        ui.cardImageView.image = stripeWrapper.getCardImage(card: card)
    }

    func didSelectCard(card: Card) {
        ui.cardImageView.image = stripeWrapper.getCardImage(card: card)
        ui.cardLabel.text = card.number + " - " + (card.userName ?? "")
        selectedCard = card
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

