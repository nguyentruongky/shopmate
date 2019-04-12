//
//  Boss.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class Boss: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let productsController = ProductsController()
        productsController.navigationItem.title = "Products"

        let productNav = wrapToNavigation(controller: productsController,
                                          tabBarTitle: "Products",
                                          iconName: "products")


        let postsController = UIViewController()
        postsController.view.backgroundColor = .blue
        postsController.navigationItem.title = "Posts"
        let postsNav = wrapToNavigation(controller: postsController,
                                        tabBarTitle: "Posts",
                                        iconName: "posts")


        let settingController = LandingController()
        let settingNav = wrapToNavigation(controller: settingController,
                                          tabBarTitle: "Settings",
                                          iconName: "settings")

        viewControllers = [
            productNav,
            postsNav,
            settingNav,
        ]
    }

    func wrapToNavigation(controller: UIViewController,
                          tabBarTitle: String, iconName: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: controller)
        nav.tabBarItem.title = tabBarTitle
        nav.tabBarItem.image = UIImage(named: iconName)
        return nav
    }
}
