//
//  CustomLog.swift
//  Movies
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

public func DLog(_ message: String, function: String = #function) {
    
    #if DEBUG
    print("\(function): \(message)")
    #endif
}
