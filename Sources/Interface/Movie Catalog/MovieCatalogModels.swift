//
//  MovieCatalogModels.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

enum MovieCatalog {

    // MARK: Use cases
    enum Get {

        struct Request {
            
        }

        enum Response {
            case success(moviesCatalog: [MovieBaseModel])
            case failure(error: Error)
        }

        struct ViewModel {
            
            let movies: [MovieModel]?
            let errorDescription: String?
        }
    }
    
}
