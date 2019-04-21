//
//  MovieDetailsRouter.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

@objc protocol MovieDetailsRoutingLogic {

    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol MovieDetailsDataPassing {

    var dataStore: MovieDetailsDataStore? { get }
}

class MovieDetailsRouter: MovieDetailsRoutingLogic, MovieDetailsDataPassing {

    weak var viewController: MovieDetailsViewController?
    var dataStore: MovieDetailsDataStore?

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
//    func navigate(from source: MovieDetailsViewController, to destination: SomewhereViewController) {
//
//        source.show(destination, sender: nil)
//    }
//
//    // MARK: Passing data
//
//    func passData(from source: MovieDetailsDataStore, to destination: inout SomewhereDataStore) {
//
//        destination.name = source.name
//    }
}
