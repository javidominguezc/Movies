//
//  MovieDetailBaseModel.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

struct MovieDetailBaseModel {
    
    let id: Int
    let title: String?
    let imagePath: String?
    let genres: [GenreBaseModel]?
    let releaseDate: String?
    let overview: String?
}



