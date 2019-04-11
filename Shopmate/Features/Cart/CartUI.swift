//
//  CartUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension CartController {
    class UI {
        let checkoutButton = UIMaker.makeMainButton(title: "Checkout")
    }
}

class CartCell: knListCell<CartItem> {
    override func setData(data: CartItem) {
        self.data = data
        productImageView.downloadImage(from: data.url)
        priceLabel.text = data.price
        nameLabel.text = data.title
        colorButton.backgroundColor = UIColor(hex: data.color)
        sizeLabel.text = data.size
    }
    let productImageView = UIMaker.makeImageView()
    let priceLabel = UIMaker.makeLabel(font: UIFont.main(.bold, size: 18),
                                       color: .black)
    let nameLabel = UIMaker.makeLabel(font: UIFont.main(.semibold, size: 15),
                                              color: .c19)
    let colorButton = UIMaker.makeButton()
    let sizeButton = UIMaker.makeButton(font: UIFont.main(size: 12),
                                        background: .black)
    let sizeLabel = UIMaker.makeLabel(font: UIFont.main(.medium, size: 13), color: .white)
    let removeButton = UIMaker.makeButton(image: UIImage(named: "remove"))

    override func setupView() {
        addSubviews(views: productImageView, priceLabel, nameLabel, colorButton, sizeButton, removeButton, sizeLabel)

        productImageView.square(edge: 96)
        productImageView.topSuperView(space: gap)
        productImageView.leftSuperView(space: gap)

        nameLabel.leftHorizontalSpacing(toView: productImageView, space: -gap)
        nameLabel.rightSuperView(space: -gap)
        nameLabel.top(toView: productImageView, space: 4)

        let buttonHeight: CGFloat = 32
        colorButton.left(toView: nameLabel)
        colorButton.verticalSpacing(toView: nameLabel, space: 12)
        colorButton.square(edge: buttonHeight)
        colorButton.setCorner(radius: buttonHeight / 2)

        sizeButton.centerY(toView: colorButton)
        sizeButton.leftHorizontalSpacing(toView: colorButton, space: -8)
        sizeButton.square(edge: buttonHeight)
        sizeButton.setCorner(radius: buttonHeight / 2)

        sizeLabel.center(toView: sizeButton)

        priceLabel.left(toView: nameLabel)
        priceLabel.verticalSpacing(toView: colorButton, space: 12)

        productImageView.backgroundColor = .green

        let line = UIMaker.makeHorizontalLine()
        addSubview(line)
        line.horizontalSuperview()
        line.bottomSuperView(space: -gap)


    }
}

