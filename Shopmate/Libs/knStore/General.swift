//
//  GlobalSupporter.swift
//  Fixir
//
//  Created by Ky Nguyen on 3/9/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

var screenWidth: CGFloat { return UIScreen.main.bounds.width }
var screenHeight: CGFloat { return UIScreen.main.bounds.height }
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var statusBarStyle = UIStatusBarStyle.lightContent
var isStatusBarHidden = false

func run(_ action: @escaping () -> Void, after second: Double) {
    let triggerTime = DispatchTime.now() + .milliseconds(Int(second * 1000))
    DispatchQueue.main.asyncAfter(deadline: triggerTime) { action() }
}

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

func makeCall(to number: String) {
    guard let phoneUrl = URL(string: "tel://\(number)") else { return }
    guard UIApplication.shared.canOpenURL(phoneUrl) else { return }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(phoneUrl)
    } else {
        UIApplication.shared.openURL(phoneUrl)
    }
}

func openAppstore(url: String) {
    guard let link = URL(string: url) else { return }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(link)
    } else {
        UIApplication.shared.openURL(link)
    }
}

func hasNotch() -> Bool {
    return DeviceType.IS_IPHONE_X ||
        DeviceType.isIphoneXR ||
        DeviceType.isIphoneXS ||
        DeviceType.isIphoneXSMax
}

func wrap(_ controller: UIViewController) -> UINavigationController {
    return UINavigationController(rootViewController: controller)
}

func openUrlInSafari(_ url: String) {
    guard let link = URL(string: url) else { return }
    UIApplication.shared.openURL(link)
}

let isSimulator: Bool = {
    #if arch(i386) || arch(x86_64)
    return true
    #else
    return false
    #endif
}()
