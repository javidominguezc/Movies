//
//  AppAPIConfig.swift
//  Movies
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

struct AppConfig {
    
    // MARK: API BASE URLs:
    
    // MARK: App API
    internal struct APIUrl {
        
        static let baseUrl = "api.themoviedb.org/3"
        static let urlString = "https://\(baseUrl)"
        static let baseImageUrl = "image.tmdb.org/t/p"
        static let urlImageString = "https://\(baseImageUrl)"
    }
    
    internal struct APIKeys {
        
        static let apiKey = "b1f3dbbd363da4b9fd4058735dff1248"
    }
}
