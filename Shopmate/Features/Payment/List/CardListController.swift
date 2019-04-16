//
//  CardListController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class CardListController: knListController<CardCell, Card> {
    var selectedIndex: Int?
    weak var delegate: CardListDelegate?
    let stateView = knStateView()

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

        stateView.setStateContent(state: .empty, imageName: "empty_card", title: "No card added", content: "Add your card and start shopping")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    override func fetchData() {
        stateView.show(state: .loading, in: view)
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

    override func back() {
        if navigationController?.viewControllers.count == 1 {
            dismiss()
        } else {
            popToRoot()
        }
    }

    func getCards() {
        stripeWrapper.getPaymentMethods(successAction: { [weak self] cards in
            self?.datasource = cards
            if cards.isEmpty == false {
                self?.stateView.state = .success
                self?.selectedIndex = 0
            } else {
                self?.stateView.state = .empty
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
        delegate?.didSelectCard(card: datasource[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }

    @objc func addNewCard() {
        push(AddCardController())
    }
}

protocol CardListDelegate: class {
    func didSelectCard(card: Card)
}
