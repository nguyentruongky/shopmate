//
//  MenuController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class MenuController: knStaticListController {
    let ui = UI()

    override func setupView() {
        title = "Settings"
        tableView.backgroundColor = UIColor(r: 243, g: 245, b: 248)
        hideNavBar(false)
        super.setupView()
        view.addSubviews(views: tableView)
        tableView.fillSuperView()

        datasource = ui.setupView()
    }

    override func didSelectRow(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        guard let item = Item(rawValue: cell.tag) else { return }
        selectMenu(item)
    }

    func selectMenu(_ menu: Item) {
        switch menu {
        case .addressBook:
            let controller = AddressController()
            controller.hidesBottomBarWhenPushed = true
            push(controller)

        case .paymentMethod:
            let controller = CardListController()
            controller.hidesBottomBarWhenPushed = true
            push(controller)
            
        case .logout:
            break
        default:
            break
        }
    }

    func showPush(_ ctr: UIViewController) {
        ctr.hidesBottomBarWhenPushed = true
        DispatchQueue.main.async { [weak self] in
            self?.push(ctr)
        }
    }

    func showPresent(_ ctr: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.present(wrap(ctr))
        }
    }
}

extension MenuController {
    enum Item: Int {
        case myDetail
        case changePass
        case addressBook
        case paymentMethod
        case term
        case logout
        case login
        case register
    }
}
