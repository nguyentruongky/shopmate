//
//  ProductDetailController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class ProductDetailController: knStaticListController {
    let ui = UI()
    lazy var output = Interactor(controller: self)
    var data: Product?

    func setData(data: Product) {
        self.data = data
        ui.imageSlideshow.datasource = data.images

        if data.discountPrice != "$0.00" {
            ui.priceLabel.text = data.discountPrice
            ui.priceLabel.textColor = UIColor.red

            ui.discountPriceLabel.text = data.price
            ui.discountPriceLabel.strikeout()
        } else {
            ui.discountPriceLabel.text = ""
            ui.priceLabel.textColor = .black
            ui.priceLabel.text = data.price
        }

        ui.titleLabel.text = data.name
        ui.descLabel.text = data.description

        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar(true)
    }

    override func setupView() {
        super.setupView()
        datasource = ui.setupView()

        view.addSubviews(views: tableView)
        tableView.backgroundColor = .clear
        tableView.fillSuperView(space: UIEdgeInsets(top: -54))

        tableView.setHeader(ui.makeHeaderView(), height: 400)
        fetchData()

        ui.backButton.addTarget(self, action: #selector(goBack))
        ui.addButton.addTarget(self, action: #selector(addToCart))
        ui.cartButton.addTarget(self, action: #selector(showCart))
    }

    @objc func showCart() {
        let controller = CartController()
        controller.hidesBottomBarWhenPushed = true
        push(controller)
    }

    @objc func addToCart() {
        guard let productID = data?.id else { return }
        guard let color = ui.getSelectedColor() else {
            MessageHub.showError("You need to select color")
            return
        }

        guard let size = ui.getSelectedSize() else {
            MessageHub.showError("You need to select size")
            return
        }

        output.addToCart(productID: productID, size: size, color: color)
        if let badge = ui.cartButton.badge, let itemCount = Int(badge) {
            ui.cartButton.badge = "\(itemCount + 1)"
        } else {
            ui.cartButton.badge = "1"
        }
    }

    @objc func goBack() {
        pop()
    }

    override func fetchData() {
        guard let id = data?.id else { return }
        output.getProduct(id: id)
        output.getReview(productID: id)
        output.getColors()
        output.getSizes()
        output.countCartItem()
    }
}
