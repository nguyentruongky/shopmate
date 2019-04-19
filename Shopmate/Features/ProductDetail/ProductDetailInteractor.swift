//
//  ProductDetailInteractor.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

extension ProductDetailController {
    func requestSuccess(data: Product) {
        setData(data: data)
    }

    func requestFail(error: knError) {
        MessageHub.showError(error.message ?? error.code)
    }

    func getReviewSuccess(data: [knReview]) {
        if data.isEmpty == false {
            datasource.append(ui.makeReviewCell())
            ui.reviewView.datasource = data
        }
    }

    func getColorsSuccess(_ data: [Color]) {
        ui.colorView.datasource = data
    }

    func getSizesSuccess(_ data: [Size]) {
        ui.sizeView.datasource = data
    }

    func addToCartFail(error: knError) {
        MessageHub.showError(error.message ?? error.code)
    }

    func countCartItems(amount: Int) {
        ui.cartButton.addBadge(amount: amount, topSpace: -6, rightSpace: 6)
    }
}

extension ProductDetailController {
    class Interactor {
        func getProduct(id: Int) {
            GetProductDetailWorker(productID: id,
                                   successAction: successResponse,
                                   failAction: failResponse).execute()
        }

        private func successResponse(data: Product) {
            output?.requestSuccess(data: data)
        }

        private func failResponse(error: knError) {
            output?.requestFail(error: error)
        }


        func getReview(productID: Int) {
            GetProductReviewWorker(productID: productID,
                                   successAction: output?.getReviewSuccess).execute()
        }


        func getColors() {
            GetColorsWorker(successAction: output?.getColorsSuccess).execute()
        }


        func getSizes() {
            GetSizesWorker(successAction: output?.getSizesSuccess).execute()
        }


        func addToCart(productID: Int, size: String, color: String) {
            AddToCartWorker(productID: productID,
                            size: size,
                            color: color,
                            success: nil,
                            fail: output?.addToCartFail).execute()
        }


        func countCartItem() {
            GetCartItemsWorker(successAction: getCartQuantity).execute()
        }

        private func getCartQuantity(items: [CartItem]) {
            output?.countCartItems(amount: items.count)
        }

        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = ProductDetailController
}
