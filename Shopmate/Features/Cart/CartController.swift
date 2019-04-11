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
    override func setupView() {
        rowHeight = 160
        super.setupView()
        view.addSubviews(views: tableView, ui.checkoutButton)
        tableView.horizontalSuperview()
        tableView.topSuperView()
        tableView.verticalSpacingDown(toView: ui.checkoutButton, space: gap)

        ui.checkoutButton.horizontalSuperview(space: gap)
        ui.checkoutButton.bottomSuperView(space: -gap * 2)


        datasource = [
            CartItem(price: "$210",
                     quantity: 3,
                     title: "Shirt for gentle man",
                     color: "F2F2F2",
                     size: "L",
                     url: "http://brandstore.vistaprint.in//render/undecorated/product/PVAG-0Q4K507W3K1Y/RS-K82Q06W655QY/jpeg?compression=95&width=700"),
            CartItem(price: "$210",
                     quantity: 3,
                     title: "Shirt for gentle man",
                     color: "048134",
                     size: "L",
                     url: "http://brandstore.vistaprint.in//render/undecorated/product/PVAG-0Q4K507W3K1Y/RS-K82Q06W655QY/jpeg?compression=95&width=700"),
            CartItem(price: "$210",
                     quantity: 3,
                     title: "Shirt for gentle man",
                     color: "F81723",
                     size: "M",
                     url: "http://brandstore.vistaprint.in//render/undecorated/product/PVAG-0Q4K507W3K1Y/RS-K82Q06W655QY/jpeg?compression=95&width=700"),

        ]
    }
}

