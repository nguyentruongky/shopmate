//
//  Boss.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
var boss: Boss?
class Boss: UITabBarController {
    let productsController = ProductsController()

    override func viewDidLoad() {
        super.viewDidLoad()
        boss = self
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

        viewControllers = [
            productNav,
            postsNav,
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if appSetting.didLogin {
            showMenuPage()
        } else {
            showLandingPage()
        }
    }

    func showMenuPage() {
        let settingController = MenuController()
        let settingNav = wrapToNavigation(controller: settingController,
                                          tabBarTitle: "Settings",
                                          iconName: "settings")
        if viewControllers!.count > 2 {
            viewControllers?[2] = settingNav
        } else {
            viewControllers?.append(settingNav)
        }
    }

    func showLandingPage() {
        let settingController = LandingController()
        let settingNav = wrapToNavigation(controller: settingController,
                                          tabBarTitle: "Users",
                                          iconName: "profile_tab")
        if viewControllers!.count > 2 {
            viewControllers?[2] = settingNav
        } else {
            viewControllers?.append(settingNav)
        }
    }

    func wrapToNavigation(controller: UIViewController,
                          tabBarTitle: String, iconName: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: controller)
        nav.tabBarItem.title = tabBarTitle
        nav.tabBarItem.image = UIImage(named: iconName)
        return nav
    }
}
