//
//  StartPoint.swift
//  knStore
//
//  Created by Ky Nguyen Coinhako on 12/11/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

class knStartPoint {
    private init() { }
    static let main = knStartPoint()
    
    var baseUrl: String = {
        enum EndPoints: String {
            case local = "http://172.16.10.10:3000/api/v1"
            case pro = "https://www.coinhako.com/api/v1"
            case staging = "http://stage.coinesto.com/api/v1"
        }
        
        return EndPoints.pro.rawValue
    }()

    var startingController: UIViewController {
        #if DEBUG
        //        return UINavigationController(rootViewController: HKDepositCryptoCtr())
        #endif
        
        return UIViewController()
    }
    
    private func notLogin() -> UIViewController? {
        if appSetting.didLogin == false {
            return UINavigationController(rootViewController: UIViewController())
        }
        return nil
    }
}

