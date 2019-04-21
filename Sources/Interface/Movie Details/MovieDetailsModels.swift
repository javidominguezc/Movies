//
//  MovieDetailsModels.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

enum MovieDetails {

    // MARK: Use cases
    enum Get {
        
        struct Request {
            
        }
        
        enum Response {
            case success(details: MovieDetailResponseModel)
            case failure(error: Error)
            case noInternet
        }
        
        struct ViewModel {
            
            let movieDetails: MovieDetailModel?
            let errorDescription: String?
        }
    }
}
