//
//  ProductsController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class ProductsController: knGridController<ProductCell, Product> {
    lazy var output = Interactor(controller: self)
    let cartButton = BadgeButton()

    
    override func setupView() {
        columnSpacing = gap
        lineSpacing = gap
        contentInset = UIEdgeInsets(space: gap)
        itemSize = CGSize(width: screenWidth / 2 - 24, height: 200)
        super.setupView()

        view.addSubviews(views: collectionView)
        collectionView.fillSuperView()

        cartButton.setImage(UIImage(named: "cart"), for: .normal)
        cartButton.imageView?.contentMode = .scaleAspectFit
        cartButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        cartButton.addTarget(self, action: #selector(showCart))
        let cartBarButton = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartBarButton
        fetchData()
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
        output.getProducts()
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard datasource.isEmpty == false else { return }
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height - 54 {
            output.getMoreProducts()
        }
    }

    override func didSelectItem(at indexPath: IndexPath) {
        let controller = ProductDetailController()
        controller.hidesBottomBarWhenPushed = true
        controller.data = datasource[indexPath.item]
        push(controller)
    }

}

