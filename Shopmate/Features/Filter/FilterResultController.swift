//
//  FilterResultController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/16/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class FilterResultController: ProductListController {
    lazy var output = Interactor(controller: self)
    var minPrice: CGFloat?
    var maxPrice: CGFloat?

    func setConditions(minPrice: CGFloat, maxPrice: CGFloat) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        fetchData()
    }

    override func fetchData() {
        guard let min = minPrice, let max = maxPrice else { return }
        output.filter(minPrice: min, maxPrice: max)
    }
}


extension FilterResultController {
    func didFilterSuccess(products: [Product]) {
        datasource = products
    }
}

extension FilterResultController {
    class Interactor {
        func filter(minPrice: CGFloat, maxPrice: CGFloat) {
            FilterProductsWorker(minPrice: minPrice, maxPrice: maxPrice, successAction: output?.didFilterSuccess).execute()
        }

        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = FilterResultController
}
