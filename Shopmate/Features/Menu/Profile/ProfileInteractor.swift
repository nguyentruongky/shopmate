//
//  ProfileInteractor.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
extension ProfileController {
    func didGetProfile(data: Customer) {
        self.data = data
        appSetting.myAccount = data
    }

    func didGetProfileFail(error: knError) {
        MessageHub.showError(error.displayMessage)
    }

    func didUpdateProfile() {
        MessageHub.showMessage("Profile updated")
        ui.saveButton.setProcess(visible: false)
    }

    func didUpdateProfileFail(error: knError) {
        MessageHub.showError(error.displayMessage)
        ui.saveButton.setProcess(visible: false)
    }
}

extension ProfileController {
    class Interactor {
        func getMyProfile() {
            GetProfileWorker(successAction: output?.didGetProfile,
                             failAction: output?.didGetProfileFail).execute()
        }

        func updateProfile(data: Customer) {
            UpdateProfileWorker(user: data,
                                success: output?.didUpdateProfile,
                                fail: output?.didUpdateProfileFail).execute()
        }

        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = ProfileController
}
