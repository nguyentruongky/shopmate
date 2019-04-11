//
//  ProductDetailController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class ProductDetailController: knStaticListController {
    let ui = UI()
    override func setupView() {
        hideNavBar(true)
        super.setupView()
        datasource = ui.setupView()

        view.addSubviews(views: tableView)
        tableView.backgroundColor = .clear
        tableView.fillSuperView(space: UIEdgeInsets(top: -54))

        tableView.setHeader(ui.makeHeaderView(), height: 400)

        ui.imageSlideshow.datasource = [
            "http://ruangperempuan.com/wp-content/uploads/2018/04/d96c6cc8d9cc8d1c.jpg",
            "https://kudo.co.id/blog/wp-content/uploads/2016/10/Cara-Jual-Online-Shop-Baju-Via-Aplikasi.jpg",
            "https://networkposting.com/wp-content/uploads/2018/02/fashion-womens-sneakers.jpg",
            "https://cdn.shopify.com/s/files/1/0293/9277/products/11-1-18_Studio_2_09-55-52_72195_Taupe0423_JF_600x.jpg?v=1541183071",

        ]
    }
}
