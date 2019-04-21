//
//  MovieDetailResponseModel.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

struct MovieDetailResponseModel {
    
    let moviesDetails: MovieDetailBaseModel
    let image: Data?
    let videos: [VideoBaseModel]?
}
