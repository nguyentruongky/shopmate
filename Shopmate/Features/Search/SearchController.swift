//
//  SearchController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/16/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class SearchController: ProductListController {
    lazy var output = Interactor(controller: self)
    private let searchController = UISearchController(searchResultsController: nil)
    private let instructionLabel = UIMaker.makeLabel(text: "Enter search text above...",
                                                         font: UIFont.main(size: 14),
                                                         color: .lightGray, alignment: .center)

    override func setupView() {
        super.setupView()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchBar()
        view.addSubview(instructionLabel)
        instructionLabel.fillSuperView()

        stateView.setStateContent(state: .empty, imageName: "empty_product", title: "No products found", content: "Change your keyword can help")
    }

    func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.inputAccessoryView = UIMaker.makeKeyboardDoneView()
    }

    @objc override func fetchData() {
        guard let text = searchController.searchBar.text else { return }
        output.searchProducts(keyword: text)
        instructionLabel.isHidden = true
        stateView.show(state: .loading, in: view)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard datasource.isEmpty == false else { return }
        guard let text = searchController.searchBar.text else { return }
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height - 54 {
            output.searchMore(keyword: text)
        }
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(fetchData), with: searchText, afterDelay: 0.35)
    }
}


extension SearchController {
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
}

extension SearchController {
    class Interactor {
        private var page = 1
        private var canLoad = true
        private var isLoading = false
        private var keyword = ""

        func searchProducts(keyword: String) {
            page = 1
            canLoad = true
            guard isLoading == false else { return }
            isLoading = true
            SearchProductsWorker(word: keyword,
                                 page: page,
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


        func searchMore(keyword: String) {
            guard canLoad, isLoading == false else { return }
            isLoading = true
            SearchProductsWorker(word: keyword,
                                 page: page,
                                 successAction: successResponse,
                                 failAction: failResponse).execute()
        }

        private func searchMoreSuccessResponse(data: [Product]) {
            isLoading = false
            canLoad = !data.isEmpty
            page += canLoad ? 1 : 0
            output?.getMoreSuccess(data: data)
        }

        private func searchMoreFailResponse(error: knError) {
            isLoading = false
        }

        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = SearchController
}
