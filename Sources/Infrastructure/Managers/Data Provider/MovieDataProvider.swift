//
//  MovieDataProvider.swift
//  Movies
//
//  Created by Javier Dominguez on 21/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

class MovieDataProvider {
    
    static func getCatalogFromDB() -> ([MovieBaseModel]?, [MovieImageModel]?) {
        
        var moviesModel: [MovieBaseModel]?
        var imagesModel: [MovieImageModel]?
        
        if let movies = DataBaseManager.shared.loadMoviesData() {
            
            moviesModel = movies
            imagesModel = []
            for movie in movies {
                
                let imageData = DataBaseManager.shared.loadImageData(id: movie.id, isSmall: true)
                let imageModel = MovieImageModel(id: movie.id, image: imageData)
                
                imagesModel?.append(imageModel)
            }
        }
        
        return (moviesModel, imagesModel)
    }
    
    static func saveCatalogToDB(movies: [MovieBaseModel]) {
        
        DataBaseManager.shared.saveMoviesData(movies: movies)
    }
    
    static func saveImageToDB(id: Int, image: Data, isSmall: Bool) {
        
        DataBaseManager.shared.saveImageData(id: id, image: image, isSmall: isSmall)
    }
}


