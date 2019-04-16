//
//  FilterProductsWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/16/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

import UIKit
class FilterProductsWorker {
    private var successAction: (([Product]) -> Void)?
    private var canLoadMore = false
    private var page = 1
    private var datasource = [Product]()
    private var minPrice: Double
    private var maxPrice: Double
    init(minPrice: CGFloat,
         maxPrice: CGFloat,
         successAction: (([Product]) -> Void)?) {
        self.minPrice = Double(Int(minPrice + 1))
        self.maxPrice = Double(Int(maxPrice + 1))
        self.successAction = successAction
    }

    func execute() {
        GetProductsWorker(page: page,
                          successAction: didGetProducts,
                          failAction: { [weak self] _ in
                            self?.successAction?([])
        }).execute()
    }

    func didGetProducts(products: [Product]) {
        datasource.append(contentsOf: products)
        canLoadMore = !products.isEmpty
        page += canLoadMore ? 1 : 0

        if canLoadMore {
            execute()
        } else {
            filter()
        }
    }

    private func filter() {
        let results = datasource.filter { (product) -> Bool in
            let priceString = product.price.remove("$")
            let discountPriceString = product.discountPrice.remove("$")
            guard let price = Double(priceString),
                let discountPrice = Double(discountPriceString) else { return false }
            let finalPrice = discountPrice > 0 ? discountPrice : price
            return finalPrice < maxPrice && finalPrice > minPrice
        }

        successAction?(results)
    }
}
