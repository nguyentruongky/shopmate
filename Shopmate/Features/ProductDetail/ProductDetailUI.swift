//
//  ProductDetailUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit


extension ProductDetailController {
    class UI {
        let imageSlideshow = knImageSlideView()
        let priceLabel = UIMaker.makeLabel(font: UIFont.main(.bold, size: 16),
                                           color: .black)
        let discountPriceLabel = UIMaker.makeLabel(font: UIFont.main(size: 14),
                                                   color: .black)
        let titleLabel = UIMaker.makeLabel(font: UIFont.main(.regular, size: 13),
                                           color: .darkGray)
        let likeButton = UIMaker.makeButton()
        let ratingView = UIMaker.makeView(background: .green)
        let colorView = SelectColorView()
        let sizeView = SelectSizeView()
        let addButton = UIMaker.makeMainButton(title: "Add to cart")

        let descLabel = UIMaker.makeLabel(font: UIFont.main(.medium, size: 13),
                                          color: UIColor.c19,
                                          numberOfLines: 0)
        let reviewView = knReviewSlideView()

        func getSelectedSize() -> String? {
            guard let index = sizeView.selectedIndex?.item else { return nil }
            return sizeView.datasource[index].value
        }

        func getSelectedColor() -> String? {
            guard let index = colorView.selectedIndex?.item else { return nil }
            return colorView.datasource[index].value
        }

        let backButton = UIMaker.makeButton(image: UIImage(named: "back"))
        let cartButton = UIMaker.makeButton()

        func setupView() -> [knTableCell] {
            likeButton.isHidden = true
            ratingView.isHidden = true
            colorView.datasource = [
                Color(attribute_value_id: 0, value: "green"),
                Color(attribute_value_id: 0, value: "black"),
                Color(attribute_value_id: 0, value: "blue"),
                Color(attribute_value_id: 0, value: "red"),
            ]
            sizeView.datasource = [
                Size(attribute_value_id: 0, value: ""),
                Size(attribute_value_id: 0, value: ""),
                Size(attribute_value_id: 0, value: ""),
                Size(attribute_value_id: 0, value: ""),
            ]
            return [
                makeNamePriceCell(),
                makeSelectionCell(),
                makeAddToCartCell(),
                makeDescriptionCell(),
            ]

        }

        func makeNamePriceCell() -> knTableCell {
            let cell = knTableCell()
            cell.addSubviews(views: priceLabel, titleLabel, ratingView, discountPriceLabel)
            cell.addConstraints(withFormat: "V:|-16-[v0]-4-[v1]|",
                                views: priceLabel, titleLabel)
            priceLabel.leftSuperView(space: gap)
            titleLabel.left(toView: priceLabel)

            discountPriceLabel.leftHorizontalSpacing(toView: priceLabel, space: -8)
            discountPriceLabel.centerY(toView: priceLabel)

            ratingView.rightSuperView(space: -gap)
            ratingView.centerY(toView: priceLabel)
            ratingView.size(CGSize(width: 66, height: 24))
            return cell
        }

        func makeHeaderView() -> UIView {
            func makeView(button: UIButton) -> UIView {
                let view = UIMaker.makeView(background: UIColor.white.alpha(0.5))
                view.addSubviews(views: button)
                button.fill(toView: view, space: UIEdgeInsets(space: 10))
                return view
            }

            backButton.imageView?.changeColor(to: .black)
            cartButton.translatesAutoresizingMaskIntoConstraints = false
            cartButton.setImage(UIImage(named: "cart"), for: .normal)

            let backView = makeView(button: backButton)
            let cartView = makeView(button: cartButton)

            let view = UIMaker.makeView()
            view.addSubviews(views: imageSlideshow, cartView, backView)
            imageSlideshow.fillSuperView()

            let buttonHeight: CGFloat = 44
            backView.topLeft(toView: view, top: gap * 3, left: gap)
            backView.square(edge: buttonHeight)
            backView.setCorner(radius: buttonHeight / 2)

            cartView.centerY(toView: backView)
            cartView.rightSuperView(space: -gap)
            cartView.square(edge: buttonHeight)
            cartView.setCorner(radius: buttonHeight / 2)

            return view
        }

        func makeSelectionCell() -> knTableCell {
            let stackView = UIMaker.makeStackView(axis: .horizontal,
                                                  distributon: .fillEqually,
                                                  alignment: .center,
                                                  space: 16)
            stackView.addViews([colorView, sizeView])
            colorView.vertical(toView: stackView)
            colorView.height(32)
            sizeView.vertical(toView: stackView)

            let topLine = UIMaker.makeHorizontalLine()
            let bottomLine = UIMaker.makeHorizontalLine()
            let centerLine = UIMaker.makeVerticalLine()
            let cell = knTableCell()
            cell.addSubviews(views: stackView, topLine, bottomLine, centerLine)
            topLine.horizontalSuperview()
            topLine.topSuperView(space: gap)

            stackView.horizontalSuperview(space: gap / 2)
            stackView.centerYSuperView(space: gap / 2)

            bottomLine.horizontalSuperview()
            bottomLine.bottomSuperView()

            centerLine.centerXSuperView()
            centerLine.top(toView: topLine, space: 4)
            centerLine.bottom(toView: bottomLine, space: -4)

            cell.height(88)
            return cell
        }

        func makeAddToCartCell() -> knTableCell {
            return UIMaker.wrapToCell(addButton, space: UIEdgeInsets(space: gap))
        }

        func makeDescriptionCell() -> knTableCell {
            descLabel.setLineSpacing()
            let titleLabel = UIMaker.makeLabel(text: "Description",
                                               font: .main(.bold, size: 15),
                                               color: .black)
            let cell = knTableCell()
            cell.addSubviews(views: titleLabel, descLabel)
            titleLabel.horizontalSuperview(space: gap)
            titleLabel.topSuperView(space: gap * 2)

            descLabel.horizontal(toView: titleLabel)
            descLabel.verticalSpacing(toView: titleLabel, space: 8)
            descLabel.bottom(toView: cell)

            return cell
        }

        func makeReviewCell() -> knTableCell {
            let titleLabel = UIMaker.makeLabel(text: "Review",
                                               font: .main(.bold, size: 15),
                                               color: .black)

            let cell = knTableCell()
            cell.addSubviews(views: titleLabel, reviewView)
            titleLabel.horizontalSuperview(space: gap)
            titleLabel.topSuperView(space: gap * 2)

            reviewView.horizontal(toView: titleLabel)
            reviewView.verticalSpacing(toView: titleLabel, space: 8)
            reviewView.bottom(toView: cell, space: -gap * 2)
            reviewView.height(140)

            return cell
        }
    }
}

