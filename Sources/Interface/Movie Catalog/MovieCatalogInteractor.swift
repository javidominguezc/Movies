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

    //var name: String { get set }
}

class MovieCatalogInteractor: MovieCatalogBusinessLogic, MovieCatalogDataStore {

    var presenter: MovieCatalogPresentationLogic?
    var worker: MovieCatalogWorker?
    
    var movieCatalog = [MovieBaseModel]()
    private let dispatchGroup = DispatchGroup()

    // MARK: - Get Catalog
    func getCatalog(request: MovieCatalog.Get.Request) {
        
        worker = MovieCatalogWorker()
        worker?.getCatalog(completionHandler: { [weak self] (responseResult) in
            
            var response: MovieCatalog.Get.Response
            switch responseResult {
            case .successDict(let dictResponse):
                
                // parse the response
                let catalogParser = CatalogMovieParser()
                let catalog = catalogParser.parser(dictResponse)
                
                if let catalog = catalog {
                    
                    // catalog is not nil
                    self?.getAllImages(catalog: catalog)
                } else {
                    
                    // catalog is nil
                    let description = [NSLocalizedDescriptionKey: Custom.ErrorType.localizedString(forErrorCode: Custom.ErrorType.unexpectedResponseFormat)]
                    let unexpectedError = NSError(domain: ErrorDomain.Generic,
                                                  code: Custom.ErrorType.unexpectedResponseFormat.rawValue,
                                                  userInfo: description)
                    response = MovieCatalog.Get.Response.failure(error: unexpectedError)
                    self?.presentCatalog(response: response)
                }
                
            case .error(let error):
                
                response = MovieCatalog.Get.Response.failure(error: error)
                self?.presentCatalog(response: response)
            default:
                
                let unexpectedError = NSError(domain: ErrorDomain.Generic,
                                              code: Custom.ErrorType.unexpectedResponseFormat.rawValue,
                                              userInfo: [NSLocalizedDescriptionKey: Custom.ErrorType.localizedString(forErrorCode: Custom.ErrorType.unexpectedResponseFormat)])
                response = MovieCatalog.Get.Response.failure(error: unexpectedError)
                self?.presentCatalog(response: response)
            }
        })
    }
    
    private func getAllImages(catalog: [MovieBaseModel]) {
        
        for movie in catalog {
            
            getImage(movie: movie)
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            
            // all the images finished its download
            
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
                    break
                case .error(let error):
                    
                    DLog(error.localizedDescription)
                    DLog("Error Downloading: \(imagePath)")
                    break
                default:
                    
                    DLog("Error Downloading: \(imagePath)")
                    break
                }
                
                // save movie
                
                var movieC = movie
                movieC.image = image
                self?.movieCatalog.append(movieC)
                
                // leave dispatch
                self?.dispatchGroup.leave()
            })
        }
    }
}

// MARK: - Output - Present Catalog
extension MovieCatalogInteractor {

    func presentCatalog(response: MovieCatalog.Get.Response) {
        
        presenter?.presentCatalog(response: response)
    }
}
