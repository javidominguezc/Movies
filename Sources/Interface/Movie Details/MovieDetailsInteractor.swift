//
//  MovieDetailsInteractor.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

protocol MovieDetailsBusinessLogic {

    func getMovieDetails(request: MovieDetails.Get.Request)
}

protocol MovieDetailsDataStore {

    var itemToShow: Int { get set }
}

class MovieDetailsInteractor: MovieDetailsBusinessLogic, MovieDetailsDataStore {
    
    private let dispatchGroup = DispatchGroup()
    private var mDetails: MovieDetailBaseModel?
    private var image: Data?
    private var videos: [VideoBaseModel]?
    
    var presenter: MovieDetailsPresentationLogic?
    var worker: MovieDetailsWorker?
    
    var itemToShow: Int = 0
    var movieDetails: MovieDetailResponseModel?

    // MARK: - Get movie details
    func getMovieDetails(request: MovieDetails.Get.Request) {
        
        if itemToShow != 0 {
            
            //reset values
            mDetails = nil
            image = nil
            videos = nil
            
            let id = String(itemToShow)
            
            // check internet connection
            if !NetworkManager.shared.isReachable() {
                
                // No internet connection
                // Get data from DB
                let (movieDetail, imageDetail, videosDetail) = DetailsDataProvider.getMovieDetailsFromDB(id: itemToShow)
                guard let movieDetailModel = movieDetail else {
                    
                    // no data yet
                    presentNoInternetConnection()
                    return
                }
                
                // data available to show
                
                mDetails = movieDetailModel
                image = imageDetail
                videos = videosDetail
                
                // prepare to present
                prepareToPresentDetails()
            } else {
                
                // Get data from API
                getDetailsFromAPI(id: id)
            }
        } else {
            
            // something was wrong
            presentUnexpectedError()
        }
    }
    
    private func getDetailsFromAPI(id: String) {
        
        worker = MovieDetailsWorker()
        worker?.getDetails(id: id, completionHandler: { [weak self] (responseResult) in
            
            switch responseResult {
            case .successDict(let dictResponse):
                
                // parse the response
                let detailParser = DetailMovieParser()
                let details = detailParser.parser(dictResponse)
                
                if let details = details {
                    
                    // details is not nil
                    // save details
                    self?.mDetails = details
                    
                    // save data to DB
                    if let idInt = self?.itemToShow {
                        
                        DetailsDataProvider.saveMovieDetailsToDB(id: idInt, movieDetails: details)
                    }
                    
                    self?.getResources(details: details)
                    self?.prepareToPresentDetails()
                } else {
                    
                    // details is nil
                    self?.presentErrorFormat()
                }
                
            case .error(let error):
                
                self?.presentError(error)
            default:
                
                self?.presentUnexpectedError()
            }
        })
    }
        
    private func getResources(details: MovieDetailBaseModel) {
        
        if let imagePath = mDetails?.imagePath {
        
            getImage(imagePath: imagePath)
        }
        
        if let id = mDetails?.id {
            
            let videoPath = String(id)
            getVideos(videoPath: videoPath)
        }
    }
        
    private func getImage(imagePath: String) {
        
        // enter dispatch
        dispatchGroup.enter()
        
        worker?.getImage(imagePath: imagePath, completionHandler: { [weak self] (responseResult) in
            
            switch responseResult {
            case .successData(let dataResponse):
                
                DLog("Download Finished: \(imagePath)")
                // save image
                self?.image = dataResponse
                
                // save data to DB
                if let idInt = self?.itemToShow, let imageData = self?.image {
                    
                    DetailsDataProvider.saveImageToDB(id: idInt, image: imageData)
                }
                break
            case .error(let error):
                
                DLog(error.localizedDescription)
                DLog("Error Downloading: \(imagePath)")
                self?.image = nil
                break
            default:
                
                DLog("Error Downloading: \(imagePath)")
                self?.image = nil
                break
            }
            
            // leave dispatch
            self?.dispatchGroup.leave()
        })
    }
    
    private func getVideos(videoPath: String) {
        
        // enter dispatch
        dispatchGroup.enter()
        
        worker?.getVideos(videosPath: videoPath, completionHandler: { [weak self] (responseResult) in
            
            switch responseResult {
            case .successDict(let dictResponse):
                
                // parse the response
                let videoParser = VideoParser()
                let videos = videoParser.parser(dictResponse)
                
                if let videos = videos {
                    
                    // videos is not nil
                    // save videos
                    self?.videos = videos
                    
                    // save data to DB
                    if let idInt = self?.itemToShow, let videoModel = self?.videos {
                        
                        DetailsDataProvider.saveVideos(id: idInt, videos: videoModel)
                    }
                } else {
                    
                    // videos is nil
                    self?.videos = nil
                }
                
            case .error(let error):
                
                // videos is nil - error in the call
                DLog(error.localizedDescription)
                self?.videos = nil
            default:
                
                // videos is nil - something was wrong
                self?.videos = nil
            }
            
            // leave dispatch
            self?.dispatchGroup.leave()
        })
    }
    
    private func prepareToPresentDetails() {
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            
            // all the resources finished its download
            var response: MovieDetails.Get.Response
            
            if let movieDetails = self?.mDetails {
                
                let movieDetailsResponse = MovieDetailResponseModel(moviesDetails: movieDetails, image: self?.image, videos: self?.videos)
                response = MovieDetails.Get.Response.success(details: movieDetailsResponse)
                self?.presentDetails(response: response)
            } else {
                
                self?.presentUnexpectedError()
            }
        }
    }
}
    

// MARK: - Output - Present Details
extension MovieDetailsInteractor {

    private func presentDetails(response: MovieDetails.Get.Response) {
        
        presenter?.presentDetails(response: response)
    }
}

// MARK: - Present Errors
extension MovieDetailsInteractor {
    
    private func presentNoInternetConnection() {
        
        let response: MovieDetails.Get.Response
        response = MovieDetails.Get.Response.noInternet
        presentDetails(response: response)
    }
    
    private func presentErrorFormat() {
        
        let response: MovieDetails.Get.Response
        let description = [NSLocalizedDescriptionKey: Custom.ErrorType.localizedString(forErrorCode: Custom.ErrorType.unexpectedResponseFormat)]
        let unexpectedError = NSError(domain: ErrorDomain.Generic,
                                      code: Custom.ErrorType.unexpectedResponseFormat.rawValue,
                                      userInfo: description)
        response = MovieDetails.Get.Response.failure(error: unexpectedError)
        presentDetails(response: response)
    }
    
    private func presentError(_ error: Error) {
        
        let response: MovieDetails.Get.Response
        response = MovieDetails.Get.Response.failure(error: error)
        presentDetails(response: response)
    }
    
    private func presentUnexpectedError() {
        
        let response: MovieDetails.Get.Response
        let unexpectedError = NSError(domain: ErrorDomain.Generic,
                                      code: Custom.ErrorType.unexpectedResponseFormat.rawValue,
                                      userInfo: [NSLocalizedDescriptionKey: Custom.ErrorType.localizedString(forErrorCode: Custom.ErrorType.unexpectedResponseFormat)])
        response = MovieDetails.Get.Response.failure(error: unexpectedError)
        presentDetails(response: response)
    }
}
