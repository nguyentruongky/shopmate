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
    var shippingRegions = [Region]()
    var data: Address? { didSet {
        ui.addressTextField.text = data?.address1
        ui.cityTextField.text = data?.city
        ui.zipTextField.text = data?.postalCode
        ui.countryTextField.text = data?.country
        ui.regionTextField.text = data?.region
        }}
    var delegate: AddressDelegate?

    override func back() {
        if navigationController?.viewControllers.count == 1 {
            dismiss()
            guard let data = data else { return }
            delegate?.didSelectAddress(data)
        } else {
            popToRoot()
        }
    }

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
        ui.regionButton.addTarget(self, action: #selector(showRegionPicker))
        fetchData()
    }

    override func fetchData() {
        output.getRegions()
        if appSetting.myAccount?.address == nil {
            GetProfileWorker(successAction: { [weak self] myAccount in
                appSetting.myAccount = myAccount
                self?.data = myAccount.address
                }, failAction: nil).execute()
        } else {
            data = appSetting.myAccount?.address
        }
    }

    @objc func showRegionPicker() {
        ui.picker?.delegate = self
        ui.picker?.show(in: self)
    }

    @objc func saveChanges(){
        hideKeyboard()
        if data == nil {
            data = Address()
        }
        data?.address1 = ui.addressTextField.text
        data?.country = ui.countryTextField.text
        data?.city = ui.cityTextField.text
        data?.postalCode = ui.zipTextField.text
        data?.region = ui.regionTextField.text

        output.saveAddress(address: data!)
        ui.saveButton.setProcess(visible: true)
    }
}

extension AddressController: knPickerViewDelegate {
    func didSelectText(_ text: String) {
        guard let index = shippingRegions.firstIndex(where: { $0.shipping_region == text }) else { return }
        if data == nil {
            data = Address()
        }
        let region = shippingRegions[Int(index)]
        data?.shippingRegionId = region.shipping_region_id
        ui.regionTextField.text = region.shipping_region
    }
}
extension AddressController {
    func didUpdate() {
        ui.saveButton.setProcess(visible: false)
        MessageHub.showMessage("Address updated")
    }

    func didUpdateFail(_ err: knError) {
        ui.saveButton.setProcess(visible: false)
        MessageHub.showError(err.message ?? err.code)
    }

    func didGetRegions(data: [Region]) {
        shippingRegions = data
        ui.makePicker(datasource: data)
    }
}

extension AddressController {
    class Interactor {
        func getRegions() {
            GetShippingAreasWorker(successAction: { [weak self] regions in
                self?.output?.didGetRegions(data: regions)
            }).execute()
        }

        func saveAddress(address: Address) {
            AddAddressWorker(address: address,
                             success: output?.didUpdate,
                             fail: output?.didUpdateFail).execute()
        }

        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = AddressController
}

protocol AddressDelegate: class {
    func didSelectAddress(_ address: Address)
}

