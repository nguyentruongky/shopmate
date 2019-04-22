//
//  ProductsController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class ProductsController: ProductListController {
    lazy var output = Interactor(controller: self)
    let cartButton = UIMaker.makeButton()
    let filterView = FilterView()
    let filterButton = UIMaker.makeButton(image: UIImage(named: "filter_off"))
    var filterController: FilterResultController?
    let categoryView = CategoryView()
    var selectedCategory: Category?
    
    override func setupView() {
        categoryView.productsController = self

        super.setupView()
        cartButton.setImage(UIImage(named: "cart"), for: .normal)
        cartButton.imageView?.contentMode = .scaleAspectFit
        cartButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        cartButton.addTarget(self, action: #selector(showCart))
        let cartBarButton = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartBarButton

        let filterBarButton = UIBarButtonItem(customView: filterButton)
        navigationItem.leftBarButtonItem = filterBarButton

        filterView.applyButton.addTarget(self, action: #selector(applyFilter))
        filterView.clearButton.addTarget(self, action: #selector(clearFilter))
        filterButton.addTarget(self, action: #selector(showFilterOption))

        collectionView.removeFromSuperview()
        view.addSubviews(views: collectionView, categoryView)
        categoryView.horizontalSuperview()
        categoryView.top(toAnchor: view.safeAreaLayoutGuide.topAnchor, space: gap)
        categoryView.height(48)

        collectionView.horizontalSuperview()
        collectionView.verticalSpacing(toView: categoryView, space: gap)
        collectionView.bottom(toAnchor: view.safeAreaLayoutGuide.bottomAnchor)

        fetchData()
    }

    @objc func showFilterOption() {
        filterView.slider.minValue = 0
        filterView.slider.maxValue = 50
        filterView.show(in: view)
    }

    @objc func applyFilter() {
        filterView.dismiss()
        title = "Filter"
        filterButton.setImage(UIImage(named: "filter_on"), for: .normal)
        if filterController == nil {
            filterController = FilterResultController()
        }

        let minPrice = filterView.slider.selectedMinValue
        let maxPrice = filterView.slider.selectedMaxValue
        filterController?.setConditions(minPrice: minPrice, maxPrice: maxPrice)
        view.addSubviews(views: filterController!.view)
        filterController!.view.translatesAutoresizingMaskIntoConstraints = false
        filterController!.view.horizontalSuperview()
        filterController!.view.top(toAnchor: view.safeAreaLayoutGuide.topAnchor)
        filterController!.view.bottom(toAnchor: view.safeAreaLayoutGuide.bottomAnchor)
    }

    @objc func clearFilter() {
        title = "Products"
        filterButton.setImage(UIImage(named: "filter_off"), for: .normal)
        filterView.dismiss()
        filterController?.view.removeFromSuperview()
        filterView.slider.selectedMaxValue = filterView.slider.maxValue
    }

    @objc func showCart() {
        let loginChecker = LoginChecker()
        if loginChecker.didLogin() == false {
            loginChecker.showLogin()
            return
        }
        
        let controller = CartController()
        controller.hidesBottomBarWhenPushed = true
        push(controller)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar(false)
        output.countCartItems()
    }
    
    override func fetchData() {
        output.getProducts(category: selectedCategory)
        output.getCategories()
        stateView.show(state: .loading, in: view)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard datasource.isEmpty == false else { return }
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height - 54 {
            output.getMoreProducts(category: selectedCategory)
        }
    }

    override func didSelectItem(at indexPath: IndexPath) {
        let controller = ProductDetailController()
        controller.hidesBottomBarWhenPushed = true
        controller.data = datasource[indexPath.item]
        push(controller)
    }

    func didSelectCategory(category: Category) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        selectedCategory = category
        output.getProducts(category: category)
    }
}

