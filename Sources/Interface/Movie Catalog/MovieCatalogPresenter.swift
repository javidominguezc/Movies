//
//  MovieCatalogPresenter.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

protocol MovieCatalogPresentationLogic {

    func presentCatalog(response: MovieCatalog.Get.Response)
}

class MovieCatalogPresenter: MovieCatalogPresentationLogic {

    weak var viewController: MovieCatalogDisplayLogic?

    // MARK: - Present Catalog
    func presentCatalog(response: MovieCatalog.Get.Response) {
        
        switch response {
        case .success(let responseArray):
            prepareCatalogSuccess(responseObj: responseArray)
        case .failure(let error):
            prepareCatalogFailure(error: error)
        case .noInternet:
            prepareCatalogNoInternet()
        }
    }
}

// MARK: - Output - Display catalog
extension MovieCatalogPresenter {

    private func prepareCatalogSuccess(responseObj: [MovieResponseModel]) {
        
        var popularMovies = [MovieModel]()
        if !responseObj.isEmpty {
            // catalog is not empy
            
            for item in responseObj {
                
                let popularMovie = MovieModel(id: item.movie.id, title: item.movie.title, image: item.image)
                popularMovies.append(popularMovie)
            }
        }
        
        let viewModel = MovieCatalog.Get.ViewModel(movies: popularMovies, errorDescription: nil)
        viewController?.displayCatalogSuccess(viewModel: viewModel)
    }
    
    private func prepareCatalogFailure(error: Error) {
        
        let errorCode = error.code
        var errorDesc = error.localizedDescription
        
        switch errorCode {
        case Custom.ErrorType.unexpectedResponseFormat.rawValue, Custom.ErrorType.endpointDoesNotExist.rawValue:
            
            errorDesc = NSLocalizedString("Something went wrong, please try again later.", comment: String(describing: MovieCatalogPresenter.self))
        default:
            break
        }
        
        let viewModel = MovieCatalog.Get.ViewModel(movies: nil, errorDescription: errorDesc)
        viewController?.displayCatalogFailure(viewModel: viewModel)
    }
    
    private func prepareCatalogNoInternet() {
        
        let viewModel = MovieCatalog.Get.ViewModel(movies: nil, errorDescription: nil)
        viewController?.displayCatalogNoInternet(viewModel: viewModel)
    }
}
