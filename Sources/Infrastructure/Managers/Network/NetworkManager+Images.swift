//
//  NetworkManager+Images.swift
//  Movies
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

extension NetworkManager {
    
    // Different sizes from image
    fileprivate struct ImageSizePath {
        
        static let small = "w200"
        static let normal = "w500"
        static let original = "original"
    }
    
    enum ImageSize {
        
        case small
        case normal
        case original
    }
    
    internal func getMovieImage(withPath pathString: String, imageSize: ImageSize, completionHandler: @escaping NetworkManagerCompletionHandler) {
        
        let imageSizePath = getImageSize(imageSize: imageSize)
        let imagePath = "\(imageSizePath)\(pathString)"
        
        print("Download Started: \(imagePath)")
        requestFile(router: Router.getMovieImage(path: imagePath), completionHandler: completionHandler)
    }
    
    fileprivate func getImageSize(imageSize: ImageSize) -> String {
        
        switch imageSize {
        case .small:
            
            return ImageSizePath.small
        case .normal:
            
            return ImageSizePath.normal
        case .original:
            
            return ImageSizePath.original
        }
    }
}
