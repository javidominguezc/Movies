//
//  MovieDetailsPresenter.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

protocol MovieDetailsPresentationLogic {

    func presentDetails(response: MovieDetails.Get.Response)
}

class MovieDetailsPresenter: MovieDetailsPresentationLogic {

    weak var viewController: MovieDetailsDisplayLogic?

    // MARK: - Present Details
    func presentDetails(response: MovieDetails.Get.Response) {
        
        switch response {
        case .success(let response):
            prepareDetailsSuccess(responseObj: response)
        case .failure(let error):
            prepareDetailsFailure(error: error)
        }
    }
}

// MARK: - Output - Display details
extension MovieDetailsPresenter {
    
    func prepareDetailsSuccess(responseObj: MovieDetailResponseModel) {
        
        let movieDetails = responseObj.moviesDetails
        let image = responseObj.image
        
        let genresString = getGenres(genresModel: movieDetails.genres)
        let videoId = getVideoId(videosModel: responseObj.videos)

        let movieDetail = MovieDetailModel(id: movieDetails.id, title: movieDetails.title, image: image, genres: genresString, releaseDate: movieDetails.releaseDate, overview: movieDetails.overview, videoId: videoId)
        
        let viewModel = MovieDetails.Get.ViewModel(movieDetails: movieDetail, errorDescription: nil)
        viewController?.displayDetailsSuccess(viewModel: viewModel)
    }
    
    func prepareDetailsFailure(error: Error) {
        
        let errorCode = error.code
        var errorDesc = error.localizedDescription
        
        switch errorCode {
        case Custom.ErrorType.unexpectedResponseFormat.rawValue, Custom.ErrorType.endpointDoesNotExist.rawValue:
            
            errorDesc = NSLocalizedString("Something went wrong, please try again later.", comment: String(describing: MovieDetailsPresenter.self))
        default:
            break
        }
        
        let viewModel = MovieDetails.Get.ViewModel(movieDetails: nil, errorDescription: errorDesc)
        viewController?.displayDetailsFailure(viewModel: viewModel)
    }
}

// MARK: - Helpers
extension MovieDetailsPresenter {
    
    // create a string with all genres names
    private func getGenres(genresModel: [GenreBaseModel]?) -> String {
        
        var genresString = ""
        if let genres = genresModel {
            
            for genre in genres {
                
                if let genreName = genre.name {
                    
                    if !genresString.isEmpty {
                        
                        genresString = genresString + ", "
                    }
                    
                    genresString = genresString + genreName
                }
            }
        }
        
        return genresString
    }
    
    // get a key id of a youtube trailer
    private func getVideoId(videosModel: [VideoBaseModel]?) -> String? {
        
        var videoId: String? = ""
        if let videos = videosModel {
            
            let video = videos.first {$0.site == "YouTube" && $0.type == "Trailer"}
            if let video = video {
                
                if let name = video.name {
                    
                    DLog("Video Found: \(name)")
                }
                
                videoId = video.key
            }
        }
        
        return videoId
    }
}
