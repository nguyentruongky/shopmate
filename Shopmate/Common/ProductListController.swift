//
//  ProductListController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/16/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//


import UIKit

class ProductListController: knGridController<ProductCell, Product> {
    let stateView = knStateView()
    
    override func setupView() {
        columnSpacing = gap
        lineSpacing = gap
        contentInset = UIEdgeInsets(space: gap)
        itemSize = CGSize(width: screenWidth / 2 - 24, height: 230)
        super.setupView()

        view.addSubviews(views: collectionView)
        collectionView.fillSuperView()
    }
}
