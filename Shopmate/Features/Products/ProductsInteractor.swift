//
//  ProductsInteractor.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension ProductsController {
    func requestSuccess(data: [Product]) {
        datasource = data
        if data.isEmpty {
            stateView.state = .empty
        } else {
            stateView.state = .success
        }
    }

    func requestFail(error: knError) {
        MessageHub.showError(error.message ?? error.code)
    }

    func getMoreSuccess(data: [Product]) {
        datasource.append(contentsOf: data)
    }

    func countCartItems(_ amount: Int) {
        cartButton.addBadge(amount: amount)
    }
}

extension ProductsController {
    class Interactor {
        private var page = 1
        private var canLoad = true
        private var isLoading = false

        func getProducts() {
            guard canLoad, isLoading == false else { return }
            isLoading = true
            GetProductsWorker(page: page,
                             successAction: successResponse,
                             failAction: failResponse).execute()
        }

        private func successResponse(data: [Product]) {
            isLoading = false
            canLoad = !data.isEmpty
            page += canLoad ? 1 : 0
            output?.requestSuccess(data: data)
        }

        private func failResponse(error: knError) {
            isLoading = false
            output?.requestFail(error: error)
        }


        func getMoreProducts() {
            guard canLoad, isLoading == false else { return }
            isLoading = true
            GetProductsWorker(page: page,
                             successAction: getMoreSuccessResponse,
                             failAction: getMoreFailResponse).execute()
        }

        private func getMoreSuccessResponse(data: [Product]) {
            isLoading = false
            canLoad = !data.isEmpty
            page += canLoad ? 1 : 0
            output?.getMoreSuccess(data: data)
        }

        private func getMoreFailResponse(error: knError) {
            isLoading = false
        }


        func countCartItems() {
            GetCartItemsWorker(successAction: { [weak self] carts in
                self?.output?.countCartItems(carts.count)
            }).execute()
        }
        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = ProductsController
}
