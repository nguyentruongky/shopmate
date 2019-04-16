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
    weak var cartController: CartController?
    
    override func setData(data: CartItem) {
        self.data = data
        priceLabel.text = data.price
        nameLabel.text = data.name
        colorButton.backgroundColor = UIColor(name: data.color)
        sizeLabel.text = data.size
        quantityLabel.text = String(data.quantity)
        stepper.value = Double(data.quantity)
    }
    let productImageView = UIMaker.makeImageView()
    let quantityLabel = UIMaker.makeLabel(font: UIFont.main(.semibold, size: 18),
                                          color: .black)
    let stepper = UIStepper()
    let priceLabel = UIMaker.makeLabel(font: UIFont.main(.bold, size: 18),
                                       color: .black)
    let nameLabel = UIMaker.makeLabel(font: UIFont.main(.semibold, size: 15),
                                      color: .c19)
    let colorButton = UIMaker.makeButton()
    let sizeButton = UIMaker.makeButton(titleColor: .black,
                                        background: .white, borderWidth: 1, borderColor: .black)
    let sizeLabel = UIMaker.makeLabel(font: UIFont.main(.medium, size: 13), color: .black)
    let removeButton = UIMaker.makeButton(image: UIImage(named: "close"))

    func getTotal() -> Double {
        guard let quantityText = quantityLabel.text,
            let quantity = Double(quantityText),
        let priceString = priceLabel.text?.remove("$"),
            let price = Double(priceString) else { return 0 }
        let total = quantity * price
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(total * multiplier) / multiplier
        return rounded
    }

    override func setupView() {
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 1
        addSubviews(views: productImageView,
                    priceLabel,
                    nameLabel,
                    colorButton,
                    sizeButton,
                    removeButton,
                    sizeLabel,
                    stepper,
                    quantityLabel)

        productImageView.square(edge: 96)
        productImageView.topSuperView(space: gap)
        productImageView.leftSuperView(space: gap)

        nameLabel.leftSuperView(space: gap)
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
        productImageView.isHidden = true

        let line = UIMaker.makeHorizontalLine()
        addSubview(line)
        line.horizontalSuperview()
        line.bottomSuperView(space: -gap)

        stepper.bottom(toView: priceLabel)
        stepper.rightSuperView(space: -gap)

        quantityLabel.leftHorizontalSpacing(toView: sizeButton, space: -8)
        quantityLabel.centerY(toView: sizeButton)
        quantityLabel.square(edge: buttonHeight)
        quantityLabel.setCorner(radius: buttonHeight / 2)
        quantityLabel.setBorder(width: 1, color: .black)
        quantityLabel.textAlignment = .center

        removeButton.top(toView: nameLabel)
        removeButton.rightSuperView(space: -gap)
        removeButton.square(edge: 44)

        stepper.addTarget(self, action: #selector(changeQuantity), for: .valueChanged)
        removeButton.addTarget(self, action: #selector(removeThisItem))
    }

    @objc func changeQuantity() {
        perform(#selector(updateQuantityToServer), with: nil, afterDelay: 1)
        quantityLabel.text = String(Int(stepper.value))
        cartController?.updateTotal()
    }

    @objc func updateQuantityToServer() {
        guard let id = data?.itemID else { return }
        UpdateCartWorker(itemID: id, quantity: Int(stepper.value),
                         successAction: nil, fail: nil).execute()
    }

    @objc func removeThisItem() {
        guard let data = data else { return }
        DeleteItemWorker(itemID: data.itemID, fail: nil).execute()
        cartController?.deleteItem(item: data)
    }
}



