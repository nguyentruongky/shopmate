//
//  ProductsUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class Product {
    var id: Int

    var images = [String]()
    var price = ""
    var discountPrice = ""
    var name = ""
    var description = ""
    var like = false
    var display = true
    
    init(raw: AnyObject) {
        id = raw["product_id"] as? Int ?? 0
        name = raw["name"] as? String ?? ""
        description = raw["description"] as? String ?? ""
        price = raw["price"] as? String ?? "0"
        price = "$" + price
        discountPrice = raw["discounted_price"] as? String ?? "0"
        discountPrice = "$" + discountPrice
        display = raw["display"] as? Bool ?? true
        if let image = raw["thumbnail"] as? String {
            let url = appSetting.baseImageURL + image
            images.append(url)
        }
        
        if let image = raw["image"] as? String {
            images = []
            let url = appSetting.baseImageURL + image
            images.append(url)
        }

        if let image = raw["image_2"] as? String {
            let url = appSetting.baseImageURL + image
            images.append(url)
        }
    }
}

class ProductCell: knGridCell<Product> {
    override func setData(data: Product) {
        self.data = data
        imageView.downloadImage(from: data.images.first)
        if data.discountPrice != "$0.00" {
            priceLabel.text = data.discountPrice
            priceLabel.textColor = UIColor.red

            discountPriceLabel.text = data.price
            discountPriceLabel.strikeout()
        } else {
            discountPriceLabel.text = ""
            priceLabel.textColor = .black
            priceLabel.text = data.price
        }

        titleLabel.text = data.name
    }

    let imageView = UIMaker.makeImageView(contentMode: .scaleAspectFill)
    let priceLabel = UIMaker.makeLabel(font: UIFont.main(.bold, size: 16),
                                       color: .black)
    let discountPriceLabel = UIMaker.makeLabel(font: UIFont.main(size: 14),
                                       color: .black)
    let titleLabel = UIMaker.makeLabel(font: UIFont.main(.regular, size: 13),
                                       color: .darkGray)
    let likeButton = UIMaker.makeButton()

    override func setupView() {
        backgroundColor = .white
        likeButton.isHidden = true
        imageView.setCorner(radius: 7)
        imageView.backgroundColor = UIColor.green

        addSubviews(views: imageView, priceLabel, discountPriceLabel, titleLabel)
        imageView.horizontalSuperview()
        imageView.topSuperView()
        imageView.height(175)

        priceLabel.leftSuperView()
        priceLabel.verticalSpacingDown(toView: titleLabel, space: -4)

        discountPriceLabel.leftHorizontalSpacing(toView: priceLabel, space: -8)
        discountPriceLabel.centerY(toView: priceLabel)

        titleLabel.horizontalSuperview()
        titleLabel.bottomSuperView()
    }
}
