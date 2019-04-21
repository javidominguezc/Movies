//
//  MovieCatalogRouter.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

@objc protocol MovieCatalogRoutingLogic {

    func routeToDetail()
}

protocol MovieCatalogDataPassing {

    var dataStore: MovieCatalogDataStore? { get }
}

class MovieCatalogRouter: MovieCatalogRoutingLogic, MovieCatalogDataPassing {

    weak var viewController: MovieCatalogViewController?
    var dataStore: MovieCatalogDataStore?
    
    // MARK: Routing
    func routeToDetail() {
        
        let destiationVC = MovieDetailsViewController()
        if let sourceDS = dataStore, var destinationDS = destiationVC.router?.dataStore {
            
            passData(from: sourceDS, to: &destinationDS)
        }
        
        if let sourceVC = viewController {
            
            navigate(from: sourceVC, to: destiationVC)
        }
    }
    
    // MARK: Navigation
    func navigate(from source: MovieCatalogViewController, to destination: MovieDetailsViewController) {
        
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    func passData(from source: MovieCatalogDataStore, to destination: inout MovieDetailsDataStore) {
        
        if let index = viewController?.sceneView.tableView.indexPathForSelectedRow?.row {
            
            destination.itemToShow = source.movieCatalog[index].movie.id
        }
    }
}
