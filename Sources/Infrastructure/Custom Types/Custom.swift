//
//  Custom.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

struct Custom {
    
    enum ErrorType: Int {
        
        case generic = -1981
        case stringLength = -1982
        case unexpectedResponseFormat = -1983
        case endpointDoesNotExist = -1984
        
        static func from(code: Int?) -> ErrorType {
            
            if let code = code, let error = ErrorType(rawValue: code) {
                
                return error
            } else {
                
                return .generic
            }
        }
        
        static func from(error: Error) -> ErrorType {
            
            return ErrorType(rawValue: (error as NSError).code) ?? .generic
        }
        
        static func localizedString(forErrorCode error: ErrorType) -> String {
            
            let defaultString = NSLocalizedString("Unexpected error", comment: "Custom.ErrorType")
            var localizedString: String?
            
            switch error {
                
            case .generic:
                localizedString = NSLocalizedString("Generic error", comment: "Custom.ErrorType")
            case .stringLength:
                localizedString = NSLocalizedString("The length of the string is insufficient", comment: "Custom.ErrorType")
            case .unexpectedResponseFormat:
                localizedString = NSLocalizedString("Response is in an unexpected format.", comment: String(describing: "Custom.ErrorType"))
            case .endpointDoesNotExist:
                localizedString = NSLocalizedString("Endpoint does not exist or is empty.", comment: String(describing: "Custom.ErrorType"))
            }
            
            return localizedString ?? defaultString
        }
    }
}
