//
//  LandingController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class LandingController: knController {
    let ui = UI()
    override func setupView() {
        hideNavBar(true)
        super.setupView()
        ui.setupView(view)

        ui.loginButton.addTarget(self, action: #selector(showLogin))
        ui.registerButton.addTarget(self, action: #selector(showRegister))
        ui.closeButton.addTarget(self, action: #selector(closeScreen))
    }

    @objc func closeScreen() {
        dismiss()
    }

    @objc func showLogin() {
        if tabBarController == nil {
            push(LoginController())
        } else {
            present(wrap(LoginController()))
        }
    }

    @objc func showRegister() {
        if tabBarController == nil {
            push(RegisterController())
        } else {
            present(wrap(RegisterController()))
        }
    }
}


extension LandingController {
    class UI {
        let background = UIMaker.makeImageView(image: UIImage(named: "landing_background"))
        let closeButton = UIMaker.makeButton(image: UIImage(named: "close"))
        let registerButton = UIMaker.makeMainButton(title: "Create account")
        let loginButton = UIMaker.makeMainButton(title: "Login",
                                                 bgColor: UIColor.white,
                                                 titleColor: .black)
        func setupView(_ view: UIView) {
            let welcomeLabel = UIMaker.makeLabel(text: "Be updated!",
                                                 font: .main(size: 28),
                                                 color: .c_163_169_175)
            let stackView = UIMaker.makeStackView(axis: .horizontal,
                                                  distributon: .fillEqually,
                                                  space: gap)
            stackView.addViews(loginButton, registerButton)
            loginButton.setBorder(width: 1, color: .black)

            view.addSubviews(views: background, welcomeLabel, stackView)
            background.fillSuperView()

            welcomeLabel.verticalSpacingDown(toView: stackView, space: -gap * 2)
            welcomeLabel.centerXSuperView()

            stackView.horizontalSuperview(space: gap)
            stackView.centerYSuperView()

            view.addSubview(closeButton)
            closeButton.square(edge: 44)
            closeButton.topRight(toView: view, top: 32, right: -32)
        }
    }
}

