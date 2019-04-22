//
//  SummaryUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/16/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension SummaryController {
    class UI {
        let addressLabel = UIMaker.makeLabel(text: "Add your address",
                                             font: .main(.medium, size: 15),
                                             color: .black,
                                             numberOfLines: 2)
        let cardLabel = UIMaker.makeLabel(font: .main(.medium, size: 15),
                                          color: .black)
        let shippingMethodLabel = UIMaker.makeLabel(text: "Select address and shipping method",
                                                    font: .main(.medium, size: 15),
                                                    color: .black)
        let cardImageView = UIMaker.makeImageView()
        let subtotalLabel = UIMaker.makeLabel(font: .main(.medium, size: 14),
                                              color: .black)
        let totalLabel = UIMaker.makeLabel(font: .main(.medium, size: 14),
                                           color: .black)
        let feeLabel = UIMaker.makeLabel(text: "$0",
                                         font: .main(.medium, size: 14),
                                         color: .black)
        let checkoutButton = UIMaker.makeMainButton(title: "Checkout")
        let pickShippingButton = UIMaker.makeButton()
        var picker: knPickerView!
        
        func makeShippingPicker(methods: [ShippingMethod]) {
            let text = methods.compactMap({ return $0.shippingType })
            picker = knPickerView.make(texts: text)
        }
        
        func setupView() -> [knTableCell] {
            addressLabel.text = "Add your address"
            shippingMethodLabel.text = "Select shipping method"
            
            let cardView = UIMaker.makeView()
            cardView.addSubviews(views: cardImageView, cardLabel)
            cardView.stackHorizontally(views: [cardImageView, cardLabel],
                                       viewSpaces: 8,
                                       leftSpace: 0, rightSpace: nil)
            cardImageView.centerYSuperView()
            cardLabel.centerYSuperView()
            cardView.height(44)
            
            let shippingCell = make2LinesCell(title: "Shipping Method", contentView: shippingMethodLabel)
            shippingCell.addSubview(pickShippingButton)
            pickShippingButton.fill(toView: shippingMethodLabel)
            
            return [
                make2LinesCell(title: "Shipping Address", contentView: addressLabel),
                make2LinesCell(title: "Payment Method", contentView: cardView),
                shippingCell,
                make1LineCell(title: "Subtotal", contentView: subtotalLabel),
                make1LineCell(title: "Fee", contentView: feeLabel),
                make1LineCell(title: "Total", contentView: totalLabel),
                UIMaker.wrapToCell(checkoutButton, space: UIEdgeInsets(space: gap))
            ]
        }
        
        func make2LinesCell(title: String, contentView: UIView) -> knTableCell {
            let label = UIMaker.makeLabel(text: title, font: .main(size: 13),
                                          color: .lightGray)
            let cell = knTableCell()
            cell.addSubviews(views: label, contentView)
            cell.stackVertically(views: [label, contentView], viewSpaces: 8, topSpace: 16, bottomSpace: 32)
            label.leftSuperView(space: gap)
            contentView.horizontalSuperview(space: gap)
            
            let line = UIMaker.makeHorizontalLine()
            cell.addSubviews(views: line)
            line.horizontalSuperview()
            line.bottomSuperView(space: -8)
            return cell
        }
        
        func make1LineCell(title: String, contentView: UIView) -> knTableCell {
            let label = UIMaker.makeLabel(text: title, font: .main(size: 13),
                                          color: .lightGray)
            let cell = knTableCell()
            cell.addSubviews(views: label, contentView)
            
            label.centerYSuperView(space: -8)
            label.leftSuperView(space: gap)
            
            contentView.rightSuperView(space: -gap)
            contentView.centerY(toView: label)
            
            cell.height(56)
            
            let line = UIMaker.makeHorizontalLine()
            cell.addSubviews(views: line)
            line.horizontalSuperview()
            line.bottomSuperView(space: -8)
            return cell
        }
    }
}


