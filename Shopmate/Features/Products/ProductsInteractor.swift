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
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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

    func didGetCategories(data: [Category]) {
        guard !data.isEmpty else { return }
        if data[0].type == .department {
            categoryView.datasource.insert(contentsOf: data, at: 0)
        } else {
            categoryView.datasource.append(contentsOf: data)
        }
    }
}

extension ProductsController {
    class Interactor {
        private var page = 1
        private var canLoad = true
        private var isLoading = false

        func getProducts(category: Category?) {
            guard isLoading == false else { return }
            isLoading = true
            page = 1
            if category == nil {
                GetProductsWorker(page: page,
                                 successAction: successResponse,
                                 failAction: failResponse).execute()
            } else {
                GetProductsInCategoryWorker(category: category!,
                                            page: page,
                                            successAction: successResponse,
                                            failAction: failResponse).execute()
            }
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


        func getMoreProducts(category: Category?) {
            guard canLoad, isLoading == false else { return }
            isLoading = true
            if category == nil {
            GetProductsWorker(page: page,
                             successAction: getMoreSuccessResponse,
                             failAction: getMoreFailResponse).execute()
            } else {
                GetProductsInCategoryWorker(category: category!,
                                            page: page,
                                            successAction: getMoreSuccessResponse,
                                            failAction: getMoreFailResponse).execute()
            }
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


        func getCategories() {
            GetCategoriesWorker(successAction: output?.didGetCategories).execute()
            GetDepartmentsWorker(successAction: output?.didGetCategories).execute()
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
