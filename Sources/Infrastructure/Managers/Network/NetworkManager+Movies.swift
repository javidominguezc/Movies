//
//  NetworkManager+Movies.swift
//  Movies
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

extension NetworkManager {
    
    internal func getPopularMovies(completionHandler: @escaping NetworkManagerCompletionHandler) {
        
        request(router: Router.getPopularMovies, completionHandler: completionHandler)
    }
    
    internal func getMovieDetails(withPath pathString: String, completionHandler: @escaping NetworkManagerCompletionHandler) {
        
        request(router: Router.getMovieDetails(path: pathString), completionHandler: completionHandler)
    }
    
    internal func getMovieVideos(withPath pathString: String, completionHandler: @escaping NetworkManagerCompletionHandler) {
        
        request(router: Router.getMovieVideos(path: pathString), completionHandler: completionHandler)
    }
}
