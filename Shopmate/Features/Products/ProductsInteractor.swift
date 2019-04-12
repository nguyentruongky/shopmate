//
//  ProductsInteractor.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

extension ProductsController {
    func requestSuccess(data: [Product]) {
        datasource = data
    }

    func requestFail(error: knError) {
        MessageHub.showError(error.message ?? error.code)
    }

    func getMoreSuccess(data: [Product]) {
        datasource.append(contentsOf: data)
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


        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = ProductsController
}
