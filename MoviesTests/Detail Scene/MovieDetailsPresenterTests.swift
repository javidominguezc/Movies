//
//  MovieDetailsPresenterTests.swift
//  MoviesTests
//
//  Created by Javier Dominguez on 22/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import XCTest
@testable import Movies

class MovieDetailsPresenterTests: XCTestCase {
    
    // MARK: Subject under test
    var sut = MovieDetailsPresenter()
    
    // MARK: Test lifecycle
    override func setUp() {
        
        super.setUp()
        setupMovieDetailsPresenter()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    // MARK: Test setup
    func setupMovieDetailsPresenter() {
        
        sut = MovieDetailsPresenter()
    }
    
    // MARK: Test doubles
    
    class MovieDetailsDisplayLogicSpy: MovieDetailsDisplayLogic {
        
        var displayDetailsSuccessCalled = false
        var displayDetailsFailureCalled = false
        var displayDetailsNoInternetCalled = false
        
        func displayDetailsSuccess(viewModel: MovieDetails.Get.ViewModel) {
            
            displayDetailsSuccessCalled = true
        }
        func displayDetailsFailure(viewModel: MovieDetails.Get.ViewModel) {
            
            displayDetailsFailureCalled = true
        }
        func displayDetailsNoInternet(viewModel: MovieDetails.Get.ViewModel){
            
            displayDetailsNoInternetCalled = true
        }
    }
    
    // MARK: Tests
    func testPresentDetails_withSuccess() {
        
        // Given
        let spy = MovieDetailsDisplayLogicSpy()
        sut.viewController = spy
        
        let movieDetails = MovieDetailBaseModel(id: 1, title: nil, imagePath: nil, genres: nil, releaseDate: nil, overview: nil)
        let details = MovieDetailResponseModel(moviesDetails: movieDetails, image: nil, videos: nil)
        let response = MovieDetails.Get.Response.success(details: details)
        
        // When
        sut.presentDetails(response: response)
        
        // Then
        XCTAssertTrue(spy.displayDetailsSuccessCalled, "presentDetails(response:) should ask the view controller to display the success result")
    }
    
    func testPresentDetails_withFailure() {
        
        // Given
        let spy = MovieDetailsDisplayLogicSpy()
        sut.viewController = spy
        let response = MovieDetails.Get.Response.failure(error: NSError(domain: "domain", code: -1, userInfo: nil))
        
        // When
        sut.presentDetails(response: response)
        
        // Then
        XCTAssertTrue(spy.displayDetailsFailureCalled, "presentDetails(response:) should ask the view controller to display the failure result")
    }
    
    func testPresentDetails_withNoInternet() {
        
        // Given
        let spy = MovieDetailsDisplayLogicSpy()
        sut.viewController = spy
        let response = MovieDetails.Get.Response.noInternet
        
        // When
        sut.presentDetails(response: response)
        
        // Then
        XCTAssertTrue(spy.displayDetailsNoInternetCalled, "presentDetails(response:) should ask the view controller to display no internet alert")
        
    }
    
}
