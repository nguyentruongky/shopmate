//
//  CardListController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class CardListController: knListController<CardCell, Card> {
    override func setupView() {
        addBackButton()
        title = "Payment methods"
        rowHeight = 66
        super.setupView()
        view.addSubviews(views: tableView)
        tableView.fillSuperView()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewCard))


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    override func fetchData() {
        if appSetting.stripeUserID == nil {
            stripeWrapper.createUser(name: nil,
                                     email: appSetting.userEmail ?? "test@test.com",
                                     successAction: { [weak self] (userKey) in
                                        stripeWrapper.userId = userKey
                                        appSetting.stripeUserID = userKey
                                        self?.getCards()
            }, failAction: nil)
        } else {
            getCards()
        }
    }

    var selectedIndex: Int?

    func getCards() {
        stripeWrapper.getPaymentMethods(successAction: { [weak self] cards in
            self?.datasource = cards
            if cards.isEmpty == false {
                self?.selectedIndex = 0
            }
        }, failAction: nil)
    }

    override func getCell(at index: IndexPath) -> UITableViewCell {
        let cell = super.getCell(at: index) as! CardCell
        cell.accessoryType = selectedIndex == index.row ? .checkmark : .none
        return cell
    }

    override func didSelectRow(at indexPath: IndexPath) {
        if let selectedIndex = selectedIndex {
            let oldCell = tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? CardCell
            oldCell?.accessoryType = .none
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }

    @objc func addNewCard() {
        push(AddCardController())
    }
}
