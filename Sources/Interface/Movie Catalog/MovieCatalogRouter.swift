//
//  MovieCatalogRouter.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

@objc protocol MovieCatalogRoutingLogic {

    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol MovieCatalogDataPassing {

    var dataStore: MovieCatalogDataStore? { get }
}

class MovieCatalogRouter: MovieCatalogRoutingLogic, MovieCatalogDataPassing {

    weak var viewController: MovieCatalogViewController?
    var dataStore: MovieCatalogDataStore?

    // MARK: Routing
    
//    func routeToSomewhere(segue: UIStoryboardSegue?) {
//
//        let destinationVC = SomewhereViewController()
//        if let sourceDS = dataStore, var destinationDS = destinationVC.router?.dataStore {
//
//            passData(from: sourceDS, to: &destinationDS)
//        }
//
//        if let sourceVC = viewController {
//            navigate(from: sourceVC, to: destinationVC)
//        }
//    }
//
//    // MARK: Navigation
//
//    func navigate(from source: MovieCatalogViewController, to destination: SomewhereViewController) {
//
//        source.show(destination, sender: nil)
//    }
//
//    // MARK: Passing data
//
//    func passData(from source: MovieCatalogDataStore, to destination: inout SomewhereDataStore) {
//
//        destination.name = source.name
//    }
}
