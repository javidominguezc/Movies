//
//  MovieCatalogInteractor.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

protocol MovieCatalogBusinessLogic {

    func getCatalog(request: MovieCatalog.Get.Request)
}

protocol MovieCatalogDataStore {

    var movieCatalog: [MovieResponseModel] { get set }
}

class MovieCatalogInteractor: MovieCatalogBusinessLogic, MovieCatalogDataStore {
    
    private let dispatchGroup = DispatchGroup()
    private var movieImages = [MovieImageModel]()

    var presenter: MovieCatalogPresentationLogic?
    var worker: MovieCatalogWorker?
    
    var movieCatalog = [MovieResponseModel]()

    // MARK: - Get Catalog
    func getCatalog(request: MovieCatalog.Get.Request) {
        
        //reset values
        movieImages = []
        movieCatalog = []
        
        // check internet connection
        if !NetworkManager.shared.isReachable() {
            
            // No internet connection
            // Get data from DB
            let (movies, images) = MovieDataProvider.getCatalogFromDB()
            guard let moviesModel = movies, !moviesModel.isEmpty else {
                
                // no data yet
                presentNoInternetConnection()
                return
            }
            
            // data available to show
            if let imagesModel = images {
                
                movieImages = imagesModel
            }
            prepareToPresentCatalog(catalog: moviesModel)
        } else {
            
            // Get data from API
            getCatalogFromAPI()
        }
    }
    
    private func getCatalogFromAPI() {
        
        worker = MovieCatalogWorker()
        worker?.getCatalog(completionHandler: { [weak self] (responseResult) in
            
            switch responseResult {
            case .successDict(let dictResponse):
                
                // parse the response
                let catalogParser = CatalogMovieParser()
                let catalog = catalogParser.parser(dictResponse)
                
                if let catalog = catalog {
                    
                    // catalog is not nil
                    
                    // save data to DB
                    MovieDataProvider.saveCatalogToDB(movies: catalog)
                    
                    // get images
                    self?.getAllImages(catalog: catalog)
                    
                    // prepare to present
                    self?.prepareToPresentCatalog(catalog: catalog)
                } else {
                    
                    // catalog is nil
                    self?.presentErrorFormat()
                }
                
            case .error(let error):
                
                self?.presentError(error)
            default:
                
                self?.presentUnexpectedError()
            }
        })
    }
    
    private func getAllImages(catalog: [MovieBaseModel]) {
        
        for movie in catalog {
            
            getImage(movie: movie)
        }
    }
    
    private func getImage(movie: MovieBaseModel) {
        
        if let imagePath = movie.imagePath {
            
            // enter dispatch
            dispatchGroup.enter()
            
            worker?.getImage(imagePath: imagePath, completionHandler: { [weak self] (responseResult) in
                
                var image: Data?
                switch responseResult {
                case .successData(let dataResponse):
                    
                    DLog("Download Finished: \(imagePath)")
                    // save image
                    image = dataResponse
                    
                    if let imageData = image {
                        
                        // save data to DB
                        MovieDataProvider.saveImageToDB(id: movie.id, image: imageData, isSmall: true)
                    }
                    break
                case .error(let error):
                    
                    DLog(error.localizedDescription)
                    DLog("Error Downloading: \(imagePath)")
                    break
                default:
                    
                    DLog("Error Downloading: \(imagePath)")
                    break
                }
                
                // save image
                let movieImage = MovieImageModel(id: movie.id, image: image)
                self?.movieImages.append(movieImage)
                
                // leave dispatch
                self?.dispatchGroup.leave()
            })
        }
    }
    
    private func prepareToPresentCatalog(catalog: [MovieBaseModel]) {
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            
            // all the images finished its download
            
            // create movieCatalog
            self?.createMovieCatalog(catalog: catalog)
        
            var response: MovieCatalog.Get.Response
            
            if let movieCatalog = self?.movieCatalog {
                
                response = MovieCatalog.Get.Response.success(moviesCatalog: movieCatalog)
            } else {
                
                let unexpectedError = NSError(domain: ErrorDomain.Generic,
                                              code: Custom.ErrorType.unexpectedResponseFormat.rawValue,
                                              userInfo: [NSLocalizedDescriptionKey: Custom.ErrorType.localizedString(forErrorCode: Custom.ErrorType.unexpectedResponseFormat)])
                response = MovieCatalog.Get.Response.failure(error: unexpectedError)
            }
            
            self?.presentCatalog(response: response)
        }
    }
    
    private func createMovieCatalog(catalog: [MovieBaseModel]) {
        
        // order movies by votes
        let orderCatalog = catalog.sorted(by: { $0.voteCount > $1.voteCount })
        for item in orderCatalog {
            
            let movieImage = movieImages.first {$0.id == item.id }
            
            // add movies to movieCatalog
            if let movieImage = movieImage {
                
                let movieResponseModel = MovieResponseModel(movie: item, image: movieImage.image)
                movieCatalog.append(movieResponseModel)
            }
        }
    }
}

// MARK: - Output - Present Catalog
extension MovieCatalogInteractor {
    
    func presentCatalog(response: MovieCatalog.Get.Response) {
        
        presenter?.presentCatalog(response: response)
    }
}

// MARK: - Present Errors
extension MovieCatalogInteractor {
    
    private func presentNoInternetConnection() {
        
        let response: MovieCatalog.Get.Response
        response = MovieCatalog.Get.Response.noInternet
        presentCatalog(response: response)
    }
    
    private func presentErrorFormat() {
        
        let response: MovieCatalog.Get.Response
        let description = [NSLocalizedDescriptionKey: Custom.ErrorType.localizedString(forErrorCode: Custom.ErrorType.unexpectedResponseFormat)]
        let unexpectedError = NSError(domain: ErrorDomain.Generic,
                                      code: Custom.ErrorType.unexpectedResponseFormat.rawValue,
                                      userInfo: description)
        response = MovieCatalog.Get.Response.failure(error: unexpectedError)
        presentCatalog(response: response)
    }
    
    private func presentError(_ error: Error) {
        
        let response: MovieCatalog.Get.Response
        response = MovieCatalog.Get.Response.failure(error: error)
        presentCatalog(response: response)
    }
    
    private func presentUnexpectedError() {
        
        let response: MovieCatalog.Get.Response
        let unexpectedError = NSError(domain: ErrorDomain.Generic,
                                      code: Custom.ErrorType.unexpectedResponseFormat.rawValue,
                                      userInfo: [NSLocalizedDescriptionKey: Custom.ErrorType.localizedString(forErrorCode: Custom.ErrorType.unexpectedResponseFormat)])
        response = MovieCatalog.Get.Response.failure(error: unexpectedError)
        presentCatalog(response: response)
    }
}
