//
//  AppDelegate.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupApp()

        test()
        return true
    }

    func test() {
        
    }

    func setupApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = Boss()
//        window!.rootViewController = wrap(AddressController())
        window!.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
    }
}

