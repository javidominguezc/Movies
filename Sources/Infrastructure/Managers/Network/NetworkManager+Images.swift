//
//  NetworkManager+Images.swift
//  Movies
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation
import UIKit

extension NetworkManager {
    
    internal func getMovieImage(withPath pathString: String, completionHandler: @escaping NetworkManagerDataHandler) {
        
        request(router: Router.getMovieImage(path: pathString), completionHandler: completionHandler)
    }
    
    func downloadImage(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        let fileName = url.lastPathComponent
        print("Download Started: \(fileName)")
        getData(from: url) { data, response, error in
            
            completionHandler(data, response, error)
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
