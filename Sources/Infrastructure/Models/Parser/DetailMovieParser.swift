//
//  DetailMovieParser.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

class DetailMovieParser {
    
    func parser(_ responseObject: Any?) -> MovieDetailBaseModel? {
        
        guard let detailInfo = responseObject as? [String: Any] else {
            
            return nil
        }
        
        let id = (detailInfo["id"] as? Int) ?? 0
        let title = detailInfo["original_title"] as? String
        let imagePath = detailInfo["backdrop_path"] as? String
        
        var genres = [GenreBaseModel]()
        if let genresInfo = detailInfo["genres"] as? [[String: Any]] {
            
            for genreInfo in genresInfo {
                
                let id = (genreInfo["id"] as? Int) ?? 0
                let name = genreInfo["name"] as? String
                
                let genre = GenreBaseModel(id: id, name: name)
                genres.append(genre)
            }
        }
        
        let releaseDate = detailInfo["release_date"] as? String
        let overview = detailInfo["overview"] as? String
        
        let movieDetails = MovieDetailBaseModel(id: id, title: title, imagePath: imagePath, genres: genres, releaseDate: releaseDate, overview: overview)
        return movieDetails
    }
}
