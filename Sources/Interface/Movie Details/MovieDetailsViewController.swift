//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

protocol MovieDetailsDisplayLogic: class {

    func displayDetailsSuccess(viewModel: MovieDetails.Get.ViewModel)
    func displayDetailsFailure(viewModel: MovieDetails.Get.ViewModel)
    func displayDetailsNoInternet(viewModel: MovieDetails.Get.ViewModel)
}

class MovieDetailsViewController: UIViewController {

    var interactor: MovieDetailsBusinessLogic?
    var router: (MovieDetailsRoutingLogic & MovieDetailsDataPassing)?

    private let sceneView = MovieDetailsView()
    private var detailsData: MovieDetailModel?
    
    private weak var weakPlayerViewController: AVPlayerViewController? = nil

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
        
        // check internet connection
        if !NetworkManager.shared.isReachable() {
            
            showNoInternectConnectionAlert(specialFeature: true) { [weak self] in
                
                self?.watchTrailerDidPress()
            }
        } else {
            
            // show trailer from youtube
            let movieTitle = detailsData?.title ?? ""
            DLog("Watch trailer for \(movieTitle)")
            if let videoId = detailsData?.videoId {
                
                DLog("Play video: \(videoId)")
                
                playVideo(videoId)
            }
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
        showError(description: viewModel.errorDescription) { [weak self] in
            
            self?.tryGetMovieDetails()
        }
    }
    
    func displayDetailsNoInternet(viewModel: MovieDetails.Get.ViewModel) {
        
        //Hide spinner
        sceneView.hideLoadingIndicator()
        
        //Show error alert
        showNoInternectConnectionAlert{ [weak self] in
            
            self?.tryGetMovieDetails()
        }
    }
}

// MARK: Routing --- Navigate next scene
extension MovieDetailsViewController {

    private func prepareForNextScene() {

        //router?.routeToNextScene()
    }
}

// MARK: - Orientation
extension MovieDetailsViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            
            let orientation = UIDevice.current.orientation
            if orientation == .portrait {
                
                self.sceneView.setPortraitMode()
            }
            else {
                
                self.sceneView.setLandscapeMode()
            }
            self.sceneView.layoutIfNeeded()
            
        }, completion: {
            _ in
        })
    }
}

extension MovieDetailsViewController {
    
    func playVideo(_ videoId: String) {
    
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        
        weakPlayerViewController = playerViewController
        XCDYouTubeClient.default().getVideoWithIdentifier(videoId) { [weak self] (video, error) in
            
            var playerSetupCorrectly = false
            
            if video != nil {
                
                if let streamURLs = video?.streamURLs {
                    
                    let streamURL = streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] ?? streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] ??
                        streamURLs[XCDYouTubeVideoQuality.small240.rawValue]
                    
                    if let url = streamURL {
                        
                        self?.weakPlayerViewController?.player = AVPlayer(url: url)
                        self?.playerPlayMovie()
                        playerSetupCorrectly = true
                    }
                }
            }
            
            if !playerSetupCorrectly {
                
                 self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func playerPlayMovie() {
        
        // add notification to know when the player played to end time
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: weakPlayerViewController?.player?.currentItem)
        
        weakPlayerViewController?.player?.play()
    }
    
    @objc private func playerDidFinish(notification: Notification) {
        
        // dismiss player
        weakPlayerViewController?.dismiss(animated: true, completion: nil)
    }
}
