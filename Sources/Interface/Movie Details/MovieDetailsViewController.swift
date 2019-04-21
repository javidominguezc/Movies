//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

protocol MovieDetailsDisplayLogic: class {

    func displayDetailsSuccess(viewModel: MovieDetails.Get.ViewModel)
    func displayDetailsFailure(viewModel: MovieDetails.Get.ViewModel)
}

class MovieDetailsViewController: UIViewController {

    var interactor: MovieDetailsBusinessLogic?
    var router: (MovieDetailsRoutingLogic & MovieDetailsDataPassing)?

    private let sceneView = MovieDetailsView()
    private var detailsData: MovieDetailModel?

    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup
    private func setup() {

        let viewController = self
        let interactor = MovieDetailsInteractor()
        let presenter = MovieDetailsPresenter()
        let router = MovieDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    override func loadView() {
        view = sceneView
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        
        title = NSLocalizedString("Movie detail - title", comment: "Movie detail title")
        
        // hide content
        sceneView.hideContent()
        
        // add action to watch trailer button
        sceneView.trailerView.addTarget(self, action: #selector(watchTrailerDidPress), for: .touchUpInside)
        
        // try to get details of the movie
        tryGetMovieDetails()
    }
    
    @objc private func watchTrailerDidPress() {
        
        // show trailer from youtube
        let movieTitle = detailsData?.title ?? ""
        DLog("Watch trailer for \(movieTitle)")
        if let videoId = detailsData?.videoId {
            
            let youtubeUrl = "https://www.youtube.com/watch?v=\(videoId)"
            DLog("Video url: \(youtubeUrl)")
        }
    }
}

// MARK: Output --- Get details
extension MovieDetailsViewController {

    func tryGetMovieDetails() {

        //Show spinner
        sceneView.showLoadingIndicator()
        
        let request = MovieDetails.Get.Request()
        interactor?.getMovieDetails(request: request)
    }
}

// MARK: - Input --- Display Details
extension MovieDetailsViewController: MovieDetailsDisplayLogic {
    
    func displayDetailsSuccess(viewModel: MovieDetails.Get.ViewModel) {
        
        //Hide spinner
        sceneView.hideLoadingIndicator()
        
        if let details = viewModel.movieDetails {
            
            detailsData = details
            
            if let imageData = details.image {
                
                sceneView.imageView.image = UIImage(data: imageData)
            }
            
            sceneView.titleLabel.text = details.title ?? ""
            sceneView.genresLabel.text = details.genres ?? ""
            sceneView.dateLabel.text = details.releaseDate ?? ""
            sceneView.overviewLabel.text = details.overview ?? ""
        }
        
        //Show content
        sceneView.showContent()
    }
    
    func displayDetailsFailure(viewModel: MovieDetails.Get.ViewModel) {
        
        //Hide spinner
        sceneView.hideLoadingIndicator()
        
        //Show error alert
        showError(description: viewModel.errorDescription)
    }
    
    private func showError(description: String?) {
        
        let errorDescription = description
        
        let alert = UIAlertController(title: NSLocalizedString("Oops", comment: String(describing: MovieDetailsViewController.self)),
                                      message: errorDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: String(describing: MovieDetailsViewController.self)),
                                     style: .default,
                                     handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: Routing --- Navigate next scene
extension MovieDetailsViewController {

    private func prepareForNextScene() {

        //        router?.routeToNextScene()
    }
}
