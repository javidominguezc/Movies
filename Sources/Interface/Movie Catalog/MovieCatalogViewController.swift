//
//  MovieCatalogViewController.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

protocol MovieCatalogDisplayLogic: class {

    func displayCatalogSuccess(viewModel: MovieCatalog.Get.ViewModel)
    func displayCatalogFailure(viewModel: MovieCatalog.Get.ViewModel)
    func displayCatalogNoInternet(viewModel: MovieCatalog.Get.ViewModel)
}

class MovieCatalogViewController: UIViewController {

    var interactor: MovieCatalogBusinessLogic?
    var router: (MovieCatalogRoutingLogic & MovieCatalogDataPassing)?
    
    private let movieCellIdentifier = "MovieCellIdentifier"
    private var tableViewDatasource = [MovieModel]()
    
    let sceneView = MovieCatalogView()

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
        let interactor = MovieCatalogInteractor()
        let presenter = MovieCatalogPresenter()
        let router = MovieCatalogRouter()
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
        title = NSLocalizedString("Catalog - title", comment: "Catalog title")
        
        sceneView.tableView.dataSource = self
        sceneView.tableView.delegate = self
        sceneView.tableView.register(MovieCatalogTableViewCell.self, forCellReuseIdentifier: movieCellIdentifier)
        
        // hide table view
        sceneView.hideTableView()
        
        // try to get the catalog
        tryGetCatalogMovies()
    }
}

extension MovieCatalogViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewDatasource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellIdentifier, for: indexPath) as? MovieCatalogTableViewCell 
        
        guard let dequeuedCell = cell else {
            
            let newCell = MovieCatalogTableViewCell(style: .default, reuseIdentifier: movieCellIdentifier)
            
            return configureCell(newCell, forIndexPath: indexPath)
        }
        
        return configureCell(dequeuedCell, forIndexPath: indexPath)
    }
    
    private func configureCell(_ cell: MovieCatalogTableViewCell, forIndexPath indexPath: IndexPath) -> MovieCatalogTableViewCell {
        
        cell.selectionStyle = .none
        
        let movie = tableViewDatasource[indexPath.row]
        
        // title
        cell.titleLabel.text = movie.title
        
        // image
        if let dataImage = movie.image {
            
            cell.setImage(data: dataImage)
        } else {
            
            cell.setNoImage()
        }
        
        return cell
    }
    
    // MARK: Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        prepareForMovieDetailScene()
    }
}

// MARK: - Output --- Get Catalog
extension MovieCatalogViewController {

    func tryGetCatalogMovies() {

        //Show spinner
        sceneView.showLoadingIndicator()
        
        let request = MovieCatalog.Get.Request()
        interactor?.getCatalog(request: request)
    }
}

// MARK: - Input --- Display Catalog
extension MovieCatalogViewController: MovieCatalogDisplayLogic {
    
    func displayCatalogSuccess(viewModel: MovieCatalog.Get.ViewModel) {
        
        //Hide spinner
        sceneView.hideLoadingIndicator()
        
        // hide table view
        sceneView.showTableView()
        
        if let popularMovies = viewModel.movies {
            
            tableViewDatasource = popularMovies
            //reload table view
            sceneView.tableView.reloadData()
        }
    }
    
    func displayCatalogFailure(viewModel: MovieCatalog.Get.ViewModel) {
        
        //Hide spinner
        sceneView.hideLoadingIndicator()
        
        //Show error alert
        showError(description: viewModel.errorDescription) { [weak self] in
            
            self?.tryGetCatalogMovies()
        }
    }
    
    func displayCatalogNoInternet(viewModel: MovieCatalog.Get.ViewModel) {
        
        //Hide spinner
        sceneView.hideLoadingIndicator()
        
        //Show error alert
        showNoInternectConnectionAlert{ [weak self] in
            
            self?.tryGetCatalogMovies()
        }
    }
}

// MARK: Routing --- Navigate next scene
extension MovieCatalogViewController {

    private func prepareForMovieDetailScene() {

        router?.routeToDetail()
    }
}
