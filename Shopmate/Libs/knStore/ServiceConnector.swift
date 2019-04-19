//
//  ServiceConnector.swift
//  WorkshopFixir
//
//  Created by Ky Nguyen on 12/28/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import Foundation
import Alamofire

struct ApiConnector {
    static fileprivate var connector = AlamofireConnector()
    static private func getHeaders() -> [String: String]? {
        return [
            "Content-Type": "application/json",
            "USER-KEY": appSetting.token ?? ""
        ]
    }
    private static func getUrl(from api: String) -> URL? {
        let baseUrl = appSetting.baseURL
        let apiUrl = api.contains("http") ? api : baseUrl + api
        return URL(string: apiUrl)
    }

    static private func request(_ api: String,
                                method: HTTPMethod,
                                params: [String: Any]? = nil,
                                headers: [String: String]? = nil,
                                success: @escaping (_ result: AnyObject) -> Void,
                                fail: ((_ error: knError) -> Void)? = nil) {
        let finalHeaders = headers ?? getHeaders()
        let apiUrl = getUrl(from: api)
        connector.request(withApi: apiUrl,
                          method: method,
                          params: params,
                          header: finalHeaders,
                          success: success,
                          fail: fail)
    }

    static private func request(_ api: String,
                                method: HTTPMethod,
                                params: [String: Any]? = nil,
                                headers: [String: String]? = nil,
                                returnData: @escaping (Data) -> Void,
                                fail: ((_ error: knError) -> Void)? = nil) {
        let finalHeaders = headers ?? getHeaders()
        let apiUrl = getUrl(from: api)
        connector.request(withApi: apiUrl,
                          method: method,
                          params: params,
                          header: finalHeaders,
                          returnData: returnData,
                          fail: fail)
    }


    static func get(_ api: String,
                    params: [String: Any]? = nil,
                    headers: [String: String]? = nil,
                    success: @escaping (_ result: AnyObject) -> Void,
                    fail: ((_ error: knError) -> Void)? = nil) {
        request(api,
                method: .get,
                params: params,
                headers: headers,
                success: success,
                fail: fail)
    }

    static func get(_ api: String,
                    params: [String: Any]? = nil,
                    headers: [String: String]? = nil,
                    returnData: @escaping (Data) -> Void,
                    fail: ((_ error: knError) -> Void)? = nil) {
        request(api, method: .get,
                params: params,
                headers: headers,
                returnData: returnData,
                fail: fail)
    }


    static func put(_ api: String,
                    params: [String: Any]? = nil,
                    headers: [String: String]? = nil,
                    success: @escaping (_ result: AnyObject) -> Void,
                    fail: ((_ error: knError) -> Void)? = nil) {
        request(api,
                method: .put,
                params: params,
                headers: headers,
                success: success,
                fail: fail)
    }

    static func put(_ api: String,
                    params: [String: Any]? = nil,
                    headers: [String: String]? = nil,
                    returnData: @escaping (Data) -> Void,
                    fail: ((_ error: knError) -> Void)? = nil) {
        request(api,
                method: .put,
                params: params,
                headers: headers,
                returnData: returnData,
                fail: fail)
    }


    static func post(_ api: String,
                     params: [String: Any]? = nil,
                     headers: [String: String]? = nil,
                     success: @escaping (_ result: AnyObject) -> Void,
                     fail: ((_ error: knError) -> Void)? = nil) {
        request(api,
                method: .post,
                params: params,
                headers: headers,
                success: success,
                fail: fail)
    }

    static func post(_ api: String,
                     params: [String: Any]? = nil,
                     headers: [String: String]? = nil,
                     returnData: @escaping (Data) -> Void,
                     fail: ((_ error: knError) -> Void)? = nil) {
        request(api,
                method: .post,
                params: params,
                headers: headers,
                returnData: returnData,
                fail: fail)
    }

    static func delete(_ api: String,
                       params: [String: Any]? = nil,
                       headers: [String: String]? = nil,
                       success: @escaping (_ result: AnyObject) -> Void,
                       fail: ((_ error: knError) -> Void)? = nil) {
        request(api, method: .delete, params: params, headers: headers, success: success, fail: fail)
    }

    static func delete(_ api: String,
                       params: [String: Any]? = nil,
                       headers: [String: String]? = nil,
                       returnData: @escaping (Data) -> Void,
                       fail: ((_ error: knError) -> Void)? = nil) {
        request(api,
                method: .delete,
                params: params,
                headers: headers,
                returnData: returnData,
                fail: fail)
    }
}


struct AlamofireConnector {
    func request(withApi api: URL?,
                 method: HTTPMethod,
                 params: [String: Any]? = nil,
                 header: [String: String]? = nil,
                 success: @escaping (_ result: AnyObject) -> Void,
                 fail: ((_ error: knError) -> Void)?) {

        guard let api = api else { return }
        let encoding: ParameterEncoding = method == .get ? URLEncoding.queryString : JSONEncoding.default
        Alamofire.request(api, method: method,
                          parameters: params, encoding: encoding,
                          headers: header)
            .responseJSON { (returnData) in
                self.response(response: returnData,
                              withSuccessAction: success,
                              failAction: fail)
        }
    }

    private func response(response: DataResponse<Any>,
                          withSuccessAction success: @escaping (_ result: AnyObject) -> Void,
                          failAction fail: ((_ error: knError) -> Void)?) {
        let url = response.request?.url?.absoluteString ?? ""
        print(url)

        if let statusCode = response.response?.statusCode {
            print(statusCode)
            if statusCode == 401 {
                appSetting.token = nil
                boss?.showLandingPage()
                appSetting.removeUserData()
                return
            }
            // handle status code here: 401 -> show logout; 500 -> server error
        }

        if let error = response.result.error {
            let err = knError(code: "unknown", message: error.localizedDescription)
            fail?(err)
            return
        }

        guard let result = response.result.value else {
            // handle unknown error
            return
        }

        // handle special error convention from server
        // ...

        success(result as AnyObject)
    }


    func request(withApi api: URL?,
                 method: HTTPMethod,
                 params: [String: Any]? = nil,
                 header: [String: String]? = nil,
                 returnData: @escaping (Data) -> Void,
                 fail: ((_ error: knError) -> Void)?) {

        guard let api = api else { return }
        let encoding: ParameterEncoding = method == .get ? URLEncoding.queryString : JSONEncoding.default
        Alamofire.request(api, method: method,
                          parameters: params,
                          encoding: encoding,
                          headers: header)
            .responseJSON { (rawData) in
                self.response(response: rawData,
                              withReturnData: returnData,
                              failAction: fail)
        }
    }

    private func response(response: DataResponse<Any>,
                          withReturnData success: @escaping (Data) -> Void,
                          failAction fail: ((_ error: knError) -> Void)?) {
        let url = response.request?.url?.absoluteString ?? ""
        print(url)

        if let statusCode = response.response?.statusCode {
            print(statusCode)
            if statusCode == 401 {
                appSetting.token = nil
                boss?.showLandingPage()
                appSetting.removeUserData()
                return
            }
            // handle status code here: 401 -> show logout; 500 -> server error
        }

        if let error = response.result.error {
            let err = knError(code: "unknown", message: error.localizedDescription)
            fail?(err)
            return
        }

        guard let result = response.data else {
            // handle unknown error
            return
        }

        // handle special error convention from server
        // ...

        success(result)
    }


}

struct knError {
    var code: String = "unknown"
    var message: String?
    var data: AnyObject?
    var displayMessage: String {
        return message ?? code
    }

    init() {}
    init(code: String, message: String? = nil, data: AnyObject? = nil) {
        self.code = code
        self.message = message
        self.data = data
    }
}

