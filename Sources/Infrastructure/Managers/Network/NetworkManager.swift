//
//  NetworkManager.swift
//  Movies
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation
import Alamofire

internal struct ErrorDomain {

    static let Network = "com.24i.network.error.domain"
    static let Generic = "com.24i.generic.error.domain"
}

private struct Timeout {

    static let secondsForRequest = 30.0 // secs
    static let secondsForResource = 30.0 // secs
}

extension Error {

    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    var localizedDescription: String { return (self as NSError).localizedDescription }
    var userInfo: [String: Any] { return (self as NSError).userInfo
}
}

internal enum NetworkErrorType: Int {

    case networkAFValidateError = -6003
    case networkAFNetworkOffline = -1009
    case networkAFNetworServerHostnameNotFound = -1003
    case networkAFNetworkTimeout = -1001
    case networkBadResponse = -2
    case generic = -1
    case networkAFError = 3
    case networkBadRequest = 400
    case noContent = 204
    case networkAuthenticationFailure = 401
    case networkForbidden = 403
    case networkNotFound = 404
    case gone = 410
    case preconditionFailed = 412
    case appUpgradeRequired = 426
    case tooManyRequests = 429
    case networkInternalServerError = 500
    case networkServiceUnavailable = 503

    static func from(code: Int?) -> NetworkErrorType {

        if let code = code, let error = NetworkErrorType(rawValue: code) {

            return error
        } else {

            return .generic
        }
    }

    static func from(error: Error) -> NetworkErrorType {

        return NetworkErrorType(rawValue: (error as NSError).code) ?? .generic
    }
}

internal enum HttpMethod: String {

    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case HEAD
}

internal enum Encoding {

    case URLEncodedInURL
    case JSON

    var afEncoding: ParameterEncoding {

        switch self {

        case .URLEncodedInURL:
            return URLEncoding.default
        case .JSON:
            return JSONEncoding.default
        }
    }
}

internal enum ReachabilityStatus {

    case unknow
    case notReachable
    case reachable
}

internal struct ErrorInfo {

    let code: Int
    let description: String
}

internal enum NetworkResult {

    case successDict(response: [String: Any])
    case successArray(response: [[String: Any]])
    case successData(response: Data)
    case successEmpty
    //    case failure(errorInfo: ErrorInfo, context: String)
    case error(error: Error)
}

typealias NetworkManagerSuccessHandler = (_ responseObject: Any?) -> ()
typealias NetworkManagerDataHandler = (_ responseData: Data) -> ()
typealias NetworkManagerErrorHandler = (_ error: Error) -> ()
typealias NetworkManagerListenerHandler = (_ status: ReachabilityStatus) -> ()
typealias NetworkManagerCompletionHandler = (_ result: NetworkResult) -> ()

class NetworkManager: Alamofire.SessionManager {

    static let shared = NetworkManager()
    private let reachabilityManager: NetworkReachabilityManager?

    private class func defaultConfiguration() -> URLSessionConfiguration {

        let additionalHeaders = ["Content-Type": "application/json; charset=utf-8", "Cache-Control": "no-cache"]
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = Timeout.secondsForRequest
        sessionConfig.timeoutIntervalForResource = Timeout.secondsForResource
        sessionConfig.httpAdditionalHeaders = additionalHeaders

        return sessionConfig
    }

    // MARK: - Init
    init() {

        reachabilityManager = NetworkReachabilityManager()
        super.init(configuration: NetworkManager.defaultConfiguration())
    }

    private let logResponse: DataRequest.Validation = { (request, response, data) in

        let statusCode = response.statusCode
        if let data = data {

            let reqUrlStr = request?.url?.absoluteString ?? ""
            DLog("\(reqUrlStr)\n\(String(data: data, encoding: .utf8) ?? "") -->statusCode: \(statusCode)")
        } else {

            DLog("() -->statusCode: \(statusCode)")
        }

        return DataRequest.ValidationResult.success
    }

    private enum JsonParserResult {

        case successDict(jsonObj: [String: Any])
        case successArray(jsonObj: [[String: Any]])
        case successEmpty
        case failure(error: Error)
    }

    private func jsonObjectWithData(_ data: Data) -> JsonParserResult {

        do {

            if !data.isEmpty {

                var json: Any
                try json = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)

                if let jsonObject = json as? [String: Any] {

                    return .successDict(jsonObj: jsonObject)
                } else if let jsonObject = json as? [[String: Any]] {

                    return .successArray(jsonObj: jsonObject)
                } else {
                    return .successEmpty
                }
            } else {

                return .successEmpty
            }
        } catch {

            DLog("NSJSONSerialization error: \(String(describing: error))")
            return .failure(error: error)
        }
    }

    private func parseServerErrorMessage(errorData: Data?, response: HTTPURLResponse?) -> (context: String?, code: Int) {

        var errorContext: String?
        var errorCode = NetworkErrorType.generic.rawValue

        if let httpResponse = response {

            errorCode = httpResponse.statusCode
            errorContext = HTTPURLResponse.localizedString(forStatusCode: errorCode)
        }

        if let data = errorData {

            let errorResponse = jsonObjectWithData(data as Data)
            switch errorResponse {

            case .successDict(let errorDict):

                // look for specific error message in the response dictionaty
                errorContext = errorDict["id"] as? String

                if errorContext == "" {

                    errorContext = nil
                }

                if let eCode = errorDict["code"] as? Int {

                    errorCode = eCode
                }
            case .successArray:
                break
            case .successEmpty:
                break
            case .failure:
                break
            }
        }

        return (errorContext, errorCode)
    }

    internal func requestFile(router: URLRequestConvertible & ContextProvider, completionHandler: @escaping NetworkManagerCompletionHandler) {

        request(router)
            .validate(logResponse)
            .validate()
            .responseData { (response) in

                if let data = response.result.value {

                    completionHandler(.successData(response: data))
                } else if let error = response.result.error {

                    completionHandler(.error(error: error))
                }
        }
    }

    internal func request(router: URLRequestConvertible & ContextProvider, completionHandler: @escaping NetworkManagerDataHandler) {

        logRequest(router)
        
        super.request(router).validate(logResponse).validate().responseData { (data) in

        }
    }

    internal func request(router: URLRequestConvertible & ContextProvider, completionHandler: @escaping NetworkManagerCompletionHandler) {

        logRequest(router)
        
        super.request(router)
            .validate(logResponse)
            .validate()
            .responseJSON { [weak self] (response) in

                self?.handleResponse(response, currentContext: router.context, completion: completionHandler)
        }
    }

    private func handleResponse(_ response: DataResponse<Any>, currentContext: String, completion: @escaping NetworkManagerCompletionHandler) {

        switch response.result {

        case .success:

            if let array = response.result.value as? [[String: Any]] {

                completion(.successArray(response: array))
            } else if let dict = response.result.value as? [String: Any] {

                completion(.successDict(response: dict))
            } else if response.response?.statusCode == NetworkErrorType.noContent.rawValue {

                completion(.successEmpty)
            }
        case .failure(let error):
            
            completion(.error(error: error))
        }
    }

    private func logRequest(_ request: URLRequestConvertible & ContextProvider) {

        if let (request, params) = try? request.asURLRequestAndParams(),
            let httpMethod = HttpMethod(rawValue: request.httpMethod ?? "GET"),
            let urlString = request.url?.absoluteString {

            logRequest(httpMethod: httpMethod, urlString, parameters: params, httpBody: request.urlRequest?.httpBody, headers: request.allHTTPHeaderFields)
        }
    }

    private func logRequest(httpMethod: HttpMethod, _ URLString: URLConvertible, parameters: [String: Any]?, httpBody: Data? = nil, headers: [String: String]?) {

        var logs = ["\(httpMethod) \(URLString)"]

        if let headers = headers, !headers.isEmpty {

            if let jsonData = try? JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted),
                let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) {

                logs += ["headers:"]
                logs += jsonStr.components(separatedBy: "\n")
            }
        }

        if let parameters = parameters, !parameters.isEmpty {

            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
                let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) {

                logs += ["params:"]
                logs += jsonStr.components(separatedBy: "\n")
            }
        }

        if let body = httpBody {

            if let jsonStr = String(data: body, encoding: String.Encoding.utf8) {

                logs += ["body:"]
                logs += jsonStr.components(separatedBy: "\n")
            }
        }

    
        DLog("request: \( "\n".join(logs))")
    }
}

// MARK: Reachability
extension NetworkManager {

    internal func isReachable() -> Bool {

        return reachabilityManager?.isReachable == true
    }

    internal func isReachableViaWWAN() -> Bool {

        return reachabilityManager?.isReachableOnWWAN == true
    }

    internal func isReachableViaWiFi() -> Bool {

        return reachabilityManager?.isReachableOnEthernetOrWiFi == true
    }

    internal func trackReachability(_ withStatus: @escaping NetworkManagerListenerHandler) {

        reachabilityManager?.startListening()

        reachabilityManager?.listener = { status in

            var vtStatus = ReachabilityStatus.unknow
            if status == Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus.unknown {

                vtStatus = ReachabilityStatus.unknow
            } else if status == Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus.notReachable {

                vtStatus = ReachabilityStatus.notReachable
            } else {

                vtStatus = ReachabilityStatus.reachable
            }

            withStatus(vtStatus)
        }
    }

    internal func stopTrackingReachability() {

        reachabilityManager?.stopListening()
    }
}
