//
//  DetailsDataProvider.swift
//  Movies
//
//  Created by Javier Dominguez on 21/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation

class DetailsDataProvider {
    
    static func getMovieDetailsFromDB(id: Int) -> (MovieDetailBaseModel?, Data?, [VideoBaseModel]?) {
        
        var moviesDetailModel: MovieDetailBaseModel?
        var imageData: Data?
        var videos: [VideoBaseModel]?
        
        // get details from DB
        if let movieDetails = DataBaseManager.shared.loadMovieDetailsData(id: id), movieDetails.overview != nil , movieDetails.genres != nil, movieDetails.releaseDate != nil {
            
            moviesDetailModel = movieDetails
            
            // get image from DB
            imageData = DataBaseManager.shared.loadImageData(id: id, isSmall: false)
            
            // get videos from DB
            videos = DataBaseManager.shared.loadVideos(id: id)
        }
        
        return (moviesDetailModel, imageData, videos)
    }
    
    static func saveMovieDetailsToDB(id: Int, movieDetails: MovieDetailBaseModel) {
        
        DataBaseManager.shared.saveMovieDataDetails(id: id, movieDetails: movieDetails)
    }
    
    static func saveImageToDB(id: Int, image: Data) {
        
        DataBaseManager.shared.saveImageData(id: id, image: image, isSmall: false)
    }
    
    static func saveVideos(id: Int, videos: [VideoBaseModel]) {
        
        DataBaseManager.shared.saveVideos(id: id, videos: videos)
    }
    
    private static func getVideosFromDB(id: Int) -> [VideoBaseModel]? {
        
        return DataBaseManager.shared.loadVideos(id: id)
    }
}
