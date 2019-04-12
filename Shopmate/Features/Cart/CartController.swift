//
//  CartController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

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

        fetchData()
    }

    override func fetchData() {
        GetCartItemsWorker(successAction: didGetCart).execute()
    }

    func didGetCart(items: [CartItem]) {
        datasource = items
        title = "Cart (\(items.count))"

    }
}

