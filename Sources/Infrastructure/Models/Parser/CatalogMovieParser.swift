//
//  CatalogMovieParser.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

class CatalogMovieParser {
    
    func parser(_ responseObject: Any?) -> [MovieBaseModel]? {
        
        guard let response = responseObject as? [String: Any], let results = response["results"] as? [[String: Any]] else {
            
            return nil
        }
        
        var moviesInfo = [MovieBaseModel]()
        
        for result in results {
            
            let id = (result["id"] as? Int) ?? 0
            let title = result["original_title"] as? String
            let imagePath = result["backdrop_path"] as? String
            let voteCount = (result["vote_count"] as? Int) ?? 0
            
            let movieInfo = MovieBaseModel(id: id, title: title, imagePath: imagePath, voteCount: voteCount)
            moviesInfo.append(movieInfo)
        }

        return moviesInfo
    }
}
