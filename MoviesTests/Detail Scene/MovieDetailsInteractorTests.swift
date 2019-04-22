//
//  MovieDetailsInteractorTests.swift
//  MoviesTests
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import XCTest
@testable import Movies

class MovieDetailsInteractorTests: XCTestCase {

    // MARK: Subject under test
    var sut = MovieDetailsInteractor()
    
    // MARK: Test lifecycle
    override func setUp() {
        
        super.setUp()
        setupMovieDetailsInteractor()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    // MARK: Test setup
    func setupMovieDetailsInteractor() {
        
        sut = MovieDetailsInteractor()
    }
    
    // MARK: Test doubles
    
    class MovieDetailsPresentationLogicSpy: MovieDetailsPresentationLogic {
        
        var presentErrorResponse = false
        
        func presentDetails(response: MovieDetails.Get.Response) {
            
            switch response {
            case .success(_):
                
                presentErrorResponse = false
            default:
                
                presentErrorResponse = true
            }
        }
    }
    
    // MARK: Tests
    func testGetDetails_withInvalidId() {

        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        let request = MovieDetails.Get.Request()
        sut.itemToShow = 0

        // When
        sut.getMovieDetails(request: request)

        // Then
        XCTAssertTrue(spy.presentErrorResponse)
    }
    
    func testGetDetails_withValidId() {
        
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        var valid = false
        
        let request = MovieDetails.Get.Request()
        sut.itemToShow = 12354
        
        // When
        sut.getMovieDetails(request: request)
        valid = sut.itemToShow != 0
        
        // Then
        XCTAssertTrue(valid)
    }
    
}
