//
//  MovieCatalogWorker.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

class MovieCatalogWorker {

    func getCatalog(completionHandler: @escaping NetworkManagerCompletionHandler) {
        
        NetworkManager.shared.getPopularMovies { (responseResult) in
            
            completionHandler(responseResult)
        }
    }
    
    func getImage(imagePath: String, completionHandler: @escaping NetworkManagerCompletionHandler) {
        
        NetworkManager.shared.getMovieImage(withPath: imagePath, imageSize: .small) { (responseResult) in
            
            completionHandler(responseResult)
        }
    }
}
