//
//  SummaryInteractor.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension SummaryController {
    func didGetAddress(_ address: Address, fullAddressText: String) {
        shippingAddress = address
        if fullAddressText.isEmpty == false {
            ui.addressLabel.text = fullAddressText
        } 
        guard let shippingID = address.shippingRegionId else { return }
        output.getShippingMethod(regionID: shippingID)
    }

    func didGetShippingMethods(methods: [ShippingMethod]) {
        shippingMethods = methods
        ui.makeShippingPicker(methods: methods)
        ui.picker.delegate = self
        guard let firstMethod = methods.first else { return }
        didSelectShippingMethod(method: firstMethod)
    }
}


extension SummaryController {
    class Interactor {
        func getShippingAddress() {
            if let address = appSetting.myAccount?.address, let _ = address.address1 {
                let fullText = generateAddressTextFromAddress(address)
                output?.didGetAddress(address, fullAddressText: fullText)
            } else {
                GetProfileWorker(successAction: { [unowned self] myAccount in

                    appSetting.myAccount = myAccount
                    guard let address = myAccount.address else { return }
                    let fullText = self.generateAddressTextFromAddress(address)
                    self.output?.didGetAddress(address, fullAddressText: fullText)

                    }, failAction: nil).execute()
            }
        }

        func generateAddressTextFromAddress(_ address: Address) -> String {
            var addressComponents = [String]()
            if let data = address.address1 {
                addressComponents.append(data)
            }
            if let data = address.city {
                addressComponents.append(data)
            }
            if let data = address.postalCode {
                addressComponents.append(data)
            }
            if let data = address.country {
                addressComponents.append(data)
            }
            let fullAddress = addressComponents.joined(separator: ", ")
            return fullAddress
        }

        func getShippingMethod(regionID: Int) {
            GetShippingDetailWorker(regionID: regionID,
                                    successAction: { [weak self]  methods in

                                        self?.output?.didGetShippingMethods(methods: methods)

            }).execute()
        }

        func getPaymentMethods() {
            stripeWrapper.getPaymentMethods(successAction: { [weak self] cards in

                guard let firstCard = cards.first else { return }
                self?.output?.didSelectCard(card: firstCard)
                
                }, failAction: nil)
        }

        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = SummaryController
}


extension SummaryController.Interactor: AddressDelegate {
    func didSelectAddress(_ address: Address) {
        let fullText = generateAddressTextFromAddress(address)
        output?.didGetAddress(address, fullAddressText: fullText)
    }
}
