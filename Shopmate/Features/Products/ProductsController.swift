//
//  ProductsController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class ProductsController: knGridController<ProductCell, Product> {
    override func setupView() {
        columnSpacing = gap
        lineSpacing = gap
        contentInset = UIEdgeInsets(space: gap)
        itemSize = CGSize(width: screenWidth / 2 - 24, height: 200)
        super.setupView()
        
        fetchData()
        view.addSubviews(views: collectionView)
        collectionView.fillSuperView()
    }
    
    override func fetchData() {
        datasource = [
            Product(images: [], price: "", title: "", like: false),
            Product(images: [], price: "", title: "", like: false),
            Product(images: [], price: "", title: "", like: false),
            Product(images: [], price: "", title: "", like: false),
            Product(images: [], price: "", title: "", like: false),
            Product(images: [], price: "", title: "", like: false),
            Product(images: [], price: "", title: "", like: false),
            Product(images: [], price: "", title: "", like: false),
            Product(images: [], price: "", title: "", like: false),
            Product(images: [], price: "", title: "", like: false),
        ]
    }
}
