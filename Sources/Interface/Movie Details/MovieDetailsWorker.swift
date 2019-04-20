//
//  MovieDetailsWorker.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

class MovieDetailsWorker {

    // get details of the movie
    func getDetails(id: String, completionHandler: @escaping NetworkManagerCompletionHandler) {
        
        NetworkManager.shared.getMovieDetails(withPath: id, completionHandler: { (responseResult) in
            
             completionHandler(responseResult)
        })
    }
    
    // get image of the movie - normal quality
    func getImage(imagePath: String, completionHandler: @escaping NetworkManagerCompletionHandler) {
        
        NetworkManager.shared.getMovieImage(withPath: imagePath, imageSize: .normal) { (responseResult) in
            
            completionHandler(responseResult)
        }
    }
    
    // get videos of the movie
    func getVideos(videosPath: String, completionHandler: @escaping NetworkManagerCompletionHandler) {
        
        NetworkManager.shared.getMovieVideos(withPath: videosPath) { (responseResult) in
            
            completionHandler(responseResult)
        }
    }
}
