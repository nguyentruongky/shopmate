//
//  ProductsUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class Product {
    var images = [String]()
    var price = ""
    var title = ""
    var like = false
    init(images: [String], price: String, title: String, like: Bool) {
        self.images = images
        self.price = price
        self.title = title
        self.like = like
    }
}

class ProductCell: knGridCell<Product> {
    override func setData(data: Product) {
        self.data = data
        imageView.downloadImage(from: data.images.first)
        priceLabel.text = data.price
        titleLabel.text = data.title

    }

    let imageView = UIMaker.makeImageView()
    let priceLabel = UIMaker.makeLabel(font: UIFont.main(.bold, size: 16),
                                       color: .black)
    let titleLabel = UIMaker.makeLabel(font: UIFont.main(.regular, size: 13),
                                       color: .darkGray)
    let likeButton = UIMaker.makeButton()

    override func setupView() {
        imageView.setCorner(radius: 7)
        let stackView = UIMaker.makeStackView(axis: .vertical,
                                              distributon: .fill,
                                              alignment: .leading,
                                              space: 6)
        stackView.addViews(imageView, priceLabel, titleLabel)
        imageView.horizontalSuperview()

        addSubviews(views: stackView, likeButton)
        stackView.fillSuperView()

        likeButton.centerY(toView: priceLabel)
        likeButton.rightSuperView()
        likeButton.square(edge: 44)

        likeButton.backgroundColor = .red
        imageView.backgroundColor = .blue
        priceLabel.text = "$150"
        titleLabel.text = "Skirt"
    }
}
