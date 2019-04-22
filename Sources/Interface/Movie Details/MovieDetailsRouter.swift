//
//  MovieDetailsRouter.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

@objc protocol MovieDetailsRoutingLogic {

}

protocol MovieDetailsDataPassing {

    var dataStore: MovieDetailsDataStore? { get }
}

class MovieDetailsRouter: MovieDetailsRoutingLogic, MovieDetailsDataPassing {

    weak var viewController: MovieDetailsViewController?
    var dataStore: MovieDetailsDataStore?

    // MARK: Routing
    
}
