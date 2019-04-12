//
//  AddressController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class AddressController: knStaticListController {
    let ui = UI()
    lazy var output = Interactor(controller: self)

    override func setupView() {
        title = "Your address"
        addBackButton()

        navigationController?.hideBar(false)
        super.setupView()
        view.addSubviews(views: tableView)
        tableView.fillSuperView()
        datasource = ui.setupView()

        view.addSubviews(views: ui.saveButton)
        ui.saveButton.horizontal(toView: view, space: 16)
        ui.saveButton.bottom(toView: view, space: -54)

        ui.saveButton.addTarget(self, action: #selector(saveChanges))
    }

    @objc func saveChanges(){
        hideKeyboard()
        ui.saveButton.setProcess(visible: true)
    }
}

extension AddressController {
    func didChange(message: String) {
        ui.saveButton.setProcess(visible: false)
        MessageHub.showMessage(message)
    }

    func didChangeFail(_ err: knError) {
        ui.saveButton.setProcess(visible: false)
        MessageHub.showError(err.message ?? err.code)
    }
}

extension AddressController {
    class Interactor {

        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = AddressController
}

