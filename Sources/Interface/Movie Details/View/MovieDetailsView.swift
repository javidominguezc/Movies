//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

class MovieDetailsView: SimpleView {
    
    // MARK: Private
    private struct ViewTraits {

        // Margins
        static let topMargin: CGFloat = 15.0
        static let topMarginBig: CGFloat = 20.0
        static let bottomMargin: CGFloat = 15.0
        static let sideMargin: CGFloat = 10.0

        //Heights
        static let buttonHeight: CGFloat = 50.0
    }
    
    private let scrollView: UIScrollView
    private let trailerLabel: UILabel
    private let genresTitleLabel: UILabel
    private let dateTitleLabel: UILabel
    private let overviewTitleLabel: UILabel
    
    // MARK: Public
    let imageView: UIImageView
    let titleLabel: UILabel
    let trailerView: UIControl
    let genresLabel: UILabel
    let dateLabel: UILabel
    let overviewLabel: UILabel
    
    override init(frame: CGRect) {
        
        // scrollView
        scrollView = UIScrollView()
        
        // image
        imageView = UIImageView()
        
        // title
        titleLabel = UILabel()
        
        // trailer button
        trailerView = UIControl()
        trailerLabel = UILabel()
    
        // genres
        genresTitleLabel = UILabel()
        genresLabel = UILabel()
        
        // date
        dateTitleLabel = UILabel()
        dateLabel = UILabel()
        
        // overview
        overviewTitleLabel = UILabel()
        overviewLabel = UILabel()
        
        // Init
        super.init(frame: frame)
        
        setupViews()
        addSubviews()
        addConstraints()
    }
    
    private func setupViews() {
        
        backgroundColor = .white
        
        setupScrollView()
        setupImageView()
        setupTitleLabel()
        setupTrailerButton()
        setupGenresLabels()
        setupDateLabels()
        setupOverviewLabels()
    }
    
    private func setupScrollView() {
        
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupImageView() {
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func setupTitleLabel() {
        
        titleLabel.textColor = Color.black
        titleLabel.textAlignment = .left
        titleLabel.font = Font.MoviesBold.big
        titleLabel.numberOfLines = 0
    }
    
    private func setupTrailerButton() {
        
        trailerView.backgroundColor = Color.customGray
        trailerLabel.textColor = Color.black
        trailerLabel.textAlignment = .center
        trailerLabel.font = Font.Movies.medium
        trailerLabel.text = NSLocalizedString("Watch trailer - title", comment: "watch trailer button title")
    }
    
    private func setupGenresLabels() {
        
        genresTitleLabel.textColor = Color.black
        genresTitleLabel.textAlignment = .left
        genresTitleLabel.font = Font.MoviesBold.small
        genresTitleLabel.text = NSLocalizedString("Genres title", comment: "genres title")
        
        genresLabel.textColor = Color.black
        genresLabel.textAlignment = .left
        genresLabel.font = Font.Movies.small
        genresLabel.numberOfLines = 0
    }
    
    private func setupDateLabels() {
        
        dateTitleLabel.textColor = Color.black
        dateTitleLabel.textAlignment = .left
        dateTitleLabel.font = Font.MoviesBold.small
        dateTitleLabel.text = NSLocalizedString("Date title", comment: "date title")
        
        dateLabel.textColor = Color.black
        dateLabel.textAlignment = .left
        dateLabel.font = Font.Movies.small
        dateLabel.numberOfLines = 0
    }
    
    private func setupOverviewLabels() {
        
        overviewTitleLabel.textColor = Color.black
        overviewTitleLabel.textAlignment = .left
        overviewTitleLabel.font = Font.MoviesBold.small
        overviewTitleLabel.text = NSLocalizedString("Overview title", comment: "overview title")
        
        overviewLabel.textColor = Color.black
        overviewLabel.textAlignment = .left
        overviewLabel.font = Font.Movies.small
        overviewLabel.numberOfLines = 0
    }
    
    private func addSubviews() {
        
        // Add subviews
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(trailerView)
        trailerView.addSubview(trailerLabel)
        scrollView.addSubview(genresTitleLabel)
        scrollView.addSubview(genresLabel)
        scrollView.addSubview(dateTitleLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(overviewTitleLabel)
        scrollView.addSubview(overviewLabel)
    }
    
    private func addConstraints() {
        
        // Add constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        trailerView.translatesAutoresizingMaskIntoConstraints = false
        trailerLabel.translatesAutoresizingMaskIntoConstraints = false
        genresTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addCustomConstraints()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomConstraints() {
        
        let scrollWidth = UIScreen.main.bounds.width

        NSLayoutConstraint.activate([

            // Horizontal
            
            //scrollView
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: scrollWidth),
            
            //imageView
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: scrollWidth),
            
            //titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewTraits.sideMargin),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -ViewTraits.sideMargin),

            //trailer button
            trailerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewTraits.sideMargin),
            trailerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -ViewTraits.sideMargin),

            trailerLabel.centerXAnchor.constraint(equalTo: trailerView.centerXAnchor),

            //genres labels
            genresTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewTraits.sideMargin),
            genresTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -ViewTraits.sideMargin),

            genresLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewTraits.sideMargin),
            genresLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -ViewTraits.sideMargin),

            //date labels
            dateTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewTraits.sideMargin),
            dateTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -ViewTraits.sideMargin),

            dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewTraits.sideMargin),
            dateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -ViewTraits.sideMargin),

            //overviewlabels
            overviewTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewTraits.sideMargin),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -ViewTraits.sideMargin),

            overviewLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewTraits.sideMargin),
            overviewLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -ViewTraits.sideMargin),

            // Vertical

            //scrollView
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            //imageView
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            //titleLabel
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ViewTraits.topMargin),

            //trailer button
            trailerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewTraits.topMarginBig),
            trailerView.heightAnchor.constraint(equalToConstant: ViewTraits.buttonHeight),

            trailerLabel.centerYAnchor.constraint(equalTo: trailerView.centerYAnchor),

            //genres labels
            genresTitleLabel.topAnchor.constraint(equalTo: trailerView.bottomAnchor, constant: ViewTraits.topMarginBig),

            genresLabel.topAnchor.constraint(equalTo: genresTitleLabel.bottomAnchor),

            //date labels
            dateTitleLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: ViewTraits.topMargin),

            dateLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),

            //overviewlabels
            overviewTitleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: ViewTraits.topMargin),

            overviewLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor),
            overviewLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -ViewTraits.bottomMargin)
            ])
    }
}

// MARK: Methods to show and hide the table view
extension MovieDetailsView {
    
    func showContent() {
        
        scrollView.isHidden = false
    }
    
    func hideContent() {
        
        scrollView.isHidden = true
    }
}
