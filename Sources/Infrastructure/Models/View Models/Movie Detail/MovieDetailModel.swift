//
//  MovieDetailModel.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

struct MovieDetailModel {
    
    let movieId: Int
    let title: String?
    let imagePath: Data?
    let genres: String?
    let releaseDate: String?
    let overview: String?
    let videoId: String?
}
