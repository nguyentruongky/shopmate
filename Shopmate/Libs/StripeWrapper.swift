////
////  StripeWrapper.swift
////  OXTRUX
////
////  Created by Greg Dion on 3/11/19.
////  Copyright © 2019 OXTRUX LLX. All rights reserved.
////
//
import Foundation
import Stripe
import Alamofire

class StripeWrapper {
    private let BASEURL = "https://api.stripe.com/v1"
    var userId: String?
    private let authKey: String
    private let secretKey: String
    private let publicKey: String
    private let applePayID: String? = "merchant.com.oxtrux.oxtrux"

    init(userId: String?, authKey: String, secretKey: String, publicKey: String) {
        self.userId = userId
        self.authKey = authKey
        self.secretKey = secretKey
        self.publicKey = publicKey
        config()
    }

    init(authKey: String, secretKey: String, publicKey: String) {
        userId = nil
        self.authKey = authKey
        self.secretKey = secretKey
        self.publicKey = publicKey
        config()
    }

    func createUser(name: String?, email: String,
                    successAction: ((_ userId: String) -> Void)?,
                    failAction: ((Error) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let userId = returnData["id"] as? String else {
                var message = returnData.value(forKeyPath: "error.message") as? String
                message = message ?? "Unable to create user for \(email)"
                failAction?(NSError(domain: message!, code: -1, userInfo: nil))
                return
            }
            appSetting.stripeUserID = userId
            self.userId = userId
            successAction?(userId)
        }

        let api = "/customers"
        let description = "Create account for user \(name), email: \(email)"
        let params = [
            "description": description,
            "email": email
        ]

        execute(api: api,
                params: params,
                method: .post,
                successResponse: successResponse,
                failResponse: failAction)
    }

    func createCard(card: Card,
                    successAction: @escaping (_ cardToken: String) -> Void,
                    failAction: ((_ error: Error) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let cardId = returnData["id"] as? String else {
                failAction?(NSError(domain: "no_card_token", code: -1))
                return
            }
            successAction(cardId)
        }

        let cardParams = STPCardParams(card: card)
        STPAPIClient.shared()
            .createToken(withCard: cardParams) { (token, err) in
                guard let token = token,
                    let userId = self.userId else { return }
                let api = "/customers/\(userId)/sources"

                self.execute(api: api,
                             params: ["source": token.tokenId],
                             method: .post,
                             successResponse: successResponse,
                             failResponse: failAction)
        }
    }

    func getPaymentMethods(successAction: @escaping (_ cards: [Card]) -> Void,
                           failAction: ((_ error: Error) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let rawData = returnData["data"] as? [AnyObject] else {
                successAction([])
                return
            }

            let cards = rawData.map({ return Card(raw: $0) })
            successAction(cards)
        }

        guard let userId = userId else { return }
        let api = "/customers/\(userId)/sources?object=card"
        execute(api: api,
                method: .get,
                successResponse: successResponse,
                failResponse: failAction)
    }

    func removeCard(cardId: String,
                    successAction: (() -> Void)? = nil,
                    failAction: ((_ error: Error) -> Void)? = nil) {
        guard let userId = userId else { return }
        let api = "/customers/\(userId)/sources/\(cardId)"
        execute(api: api,
                method: .delete,
                successResponse: { _ in successAction?() },
                failResponse: failAction)
    }

    func updateCard(cardId: String,
                    expMonth: Int? = nil,
                    expYear: Int? = nil,
                    successAction: (() -> Void)? = nil,
                    failAction: ((_ error: Error) -> Void)? = nil) {
        guard let userId = userId else { return }
        var params = [String: Any]()
        if let data = expMonth {
            params["exp_month"] = data
        }

        if let data = expYear {
            params["exp_year"] = data
        }

        guard params.isEmpty == false else {
            successAction?()
            return
        }

        let api = "/customers/\(userId)/sources/\(cardId)"
        execute(api: api,
                params: params,
                method: .post,
                successResponse: { _ in successAction?() },
                failResponse: failAction)
    }

    func charge(amountInSmallestUnit amount: Double,
                currency: String, cardToken: String,
                transactionId: String,
                successAction: @escaping (_ chargeId: String) -> Void,
                failAction: ((_ error: Error) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let chargeId = returnData["receipt_url"] as? String else {
                var message = returnData.value(forKeyPath: "error.message") as? String
                message = message ?? "Can't charge at this time"
                let err = NSError(domain: message!, code: -1, userInfo: nil)
                failAction?(err)
                return
            }

            successAction(chargeId)
        }

        var params = [
            "amount": Int(amount),
            "currency": currency,
            "source": cardToken,
            "customer": userId!
            ] as [String : Any]

        var email: String?
        if let data = appSetting.userEmail {
            email = data
        }

        if let data = appSetting.myAccount?.email {
            email = data
        }

        if let email = email {
            params["receipt_email"] = email
        }
        let api = "/charges"
        execute(api: api,
                params: params,
                method: .post,
                successResponse: { returnData in
                    successResponse(returnData: returnData) },
                failResponse: failAction)

    }

    func getCardImage(card: Card) -> UIImage? {
        if let brand = getCardBrand(card: card) {
            return STPImageLibrary.brandImage(for: brand)
        }
        return nil
    }

    func getCardImage(brand: STPCardBrand) -> UIImage? {
        return STPImageLibrary.brandImage(for: brand)
    }

    private func getCardBrand(card: Card) -> STPCardBrand? {
        guard let type = card.type?.lowercased() else { return nil }
        switch type {
        case "visa":
            return STPCardBrand.visa
        case "mastercard":
            return STPCardBrand.masterCard
        case "discover":
            return STPCardBrand.discover
        case "american express":
            return STPCardBrand.amex
        default:
            return nil
        }
    }
}

extension StripeWrapper {
    private func execute(api: String,
                         params: [String: Any] = [:],
                         method: HTTPMethod,
                         successResponse: ((AnyObject) -> Void)? = nil,
                         failResponse: ((Error) -> Void)? = nil) {
        let headers = [
            "Authorization": authKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let encoding: ParameterEncoding = {
            switch method {
            case .get, .delete:
                return URLEncoding.queryString
            default:
                return URLEncoding.httpBody
            }
        }()
        guard let url = URL(string: BASEURL + api) else { return }
        Alamofire
            .request(url,
                     method: method,
                     parameters: params,
                     encoding: encoding,
                     headers: headers)
            .responseJSON { (response) in
                if let error = response.result.error {
                    failResponse?(error)
                    return
                }

                let returnData = response.result.value as AnyObject
                successResponse?(returnData)
        }
    }

    private func config() {
        STPPaymentConfiguration.shared().publishableKey = publicKey
        if let applePayId = applePayID {
            STPPaymentConfiguration.shared().appleMerchantIdentifier = applePayId
        }
    }
}



extension STPCardParams {
    convenience init(card: Card) {
        self.init()
        number = card.number.replacingOccurrences(of: "-", with: "")
        expMonth = UInt(card.expMonth) ?? 1
        expYear = UInt(card.expYear) ?? 2020
        cvc = card.cvc
        name = card.userName
    }
}


struct Card {
    var id: String?
    var number: String
    var userName: String?
    var expiration: String
    var cvc: String?
    var expMonth = ""
    var expYear = ""
    var type: String?

    init(number: String, userName: String, expiration: String, cvc: String) {
        self.number = number
        self.userName = userName
        self.expiration = expiration
        self.cvc = cvc

        let expiry = expiration.components(separatedBy: "/")
        expMonth = expiry.first ?? ""
        expYear = expiry.last ?? ""
    }

    init(raw: AnyObject) {
        if let number = raw["last4"] as? String {
            self.number = "**** " + number
        } else {
            number = ""
        }
        userName = raw["name"] as? String
        expMonth = raw["exp_month"] as? String ?? "12"
        expYear = raw["exp_year"] as? String ?? "2020"
        cvc = ""

        expiration = "\(expMonth)\(expYear)"
        id = raw["id"] as? String
        type = raw["brand"] as? String
    }
}

