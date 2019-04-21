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
    
    private var constraintsPortrait = [NSLayoutConstraint]()
    private var constraintsLandscape = [NSLayoutConstraint]()
    private var containerViewWidthConstraint = NSLayoutConstraint()
    
    private let scrollView: UIScrollView
    private let containerView: UIView
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
        
        // containerView
        containerView = UIView()
        
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
        setupContainerView()
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
    
    private func setupContainerView() {
        
        containerView.backgroundColor = .clear
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
        scrollView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(trailerView)
        trailerView.addSubview(trailerLabel)
        containerView.addSubview(genresTitleLabel)
        containerView.addSubview(genresLabel)
        containerView.addSubview(dateTitleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(overviewTitleLabel)
        containerView.addSubview(overviewLabel)
    }
    
    private func addConstraints() {
        
        // Add constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
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
    
        addPortraitCustomConstraints()
        addLandscapeCustomConstraints()
        
        if UIDevice.current.orientation.isLandscape {
            
            setLandscapeMode()
        } else {
            
            setPortraitMode()
        }

        NSLayoutConstraint.activate([

            //scrollView
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //containerView
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            //imageView
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
        
            //titleLabel
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTraits.sideMargin),

            //trailer button
            trailerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTraits.sideMargin),
            trailerView.heightAnchor.constraint(equalToConstant: ViewTraits.buttonHeight),

            trailerLabel.centerXAnchor.constraint(equalTo: trailerView.centerXAnchor),
            trailerLabel.centerYAnchor.constraint(equalTo: trailerView.centerYAnchor),
            
            //genres labels
            genresTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTraits.sideMargin),
            genresTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTraits.sideMargin),

            genresLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTraits.sideMargin),
            genresLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTraits.sideMargin),
            genresLabel.topAnchor.constraint(equalTo: genresTitleLabel.bottomAnchor),
            
            //date labels
            dateTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTraits.sideMargin),
            dateTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTraits.sideMargin),
            dateTitleLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: ViewTraits.topMargin),
            
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTraits.sideMargin),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTraits.sideMargin),
            dateLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),
            
            //overviewlabels
            overviewTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTraits.sideMargin),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTraits.sideMargin),
            overviewTitleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: ViewTraits.topMargin),
            
            overviewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTraits.sideMargin),
            overviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTraits.sideMargin),
            overviewLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor),
            overviewLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -ViewTraits.bottomMargin)
            ])
    }
    
    private func addPortraitCustomConstraints() {
        
        // image
        let imageViewConstraint = imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        constraintsPortrait.append(imageViewConstraint)
        
        // title
        let titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ViewTraits.topMargin)
        constraintsPortrait.append(titleLabelTopConstraint)
        
        let titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTraits.sideMargin)
        constraintsPortrait.append(titleLabelLeadingConstraint)
        
        // trailer button
        let trailerViewPositionConstraint = trailerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewTraits.topMarginBig)
        constraintsPortrait.append(trailerViewPositionConstraint)
        
        let trailerViewLeadingConstraint = trailerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTraits.sideMargin)
        constraintsPortrait.append(trailerViewLeadingConstraint)
        
        // genres
        let genresLabelTopConstraint = genresTitleLabel.topAnchor.constraint(equalTo: trailerView.bottomAnchor, constant: ViewTraits.topMarginBig)
        constraintsPortrait.append(genresLabelTopConstraint)
    }
    
    private func addLandscapeCustomConstraints() {

        // image
        let imageViewConstraint = imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6)
        constraintsLandscape.append(imageViewConstraint)
        
        // title
        let titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ViewTraits.topMargin)
        constraintsLandscape.append(titleLabelTopConstraint)
        
        let titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: ViewTraits.sideMargin)
        constraintsLandscape.append(titleLabelLeadingConstraint)
        
        // trailer button
        let trailerViewPositionConstraint = trailerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        constraintsLandscape.append(trailerViewPositionConstraint)
        
        let trailerViewLeadingConstraint = trailerView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: ViewTraits.sideMargin)
        constraintsLandscape.append(trailerViewLeadingConstraint)
        
        // genres
        let genresLabelTopConstraint = genresTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ViewTraits.topMargin)
        constraintsLandscape.append(genresLabelTopConstraint)
    }
    
    private func updateCustomConstraints() {
        
        var leftMargin: CGFloat = 0.0
        var rightMargin: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            
            let window = UIApplication.shared.keyWindow
            leftMargin = window?.safeAreaInsets.left ?? 0.0
            rightMargin = window?.safeAreaInsets.right ?? 0.0
        }
        
        let screenWidth = UIScreen.main.bounds.width - leftMargin - rightMargin
        
        if !containerView.constraints.contains(containerViewWidthConstraint) {
            
            // create
            containerViewWidthConstraint = containerView.widthAnchor.constraint(equalToConstant: screenWidth)
            containerViewWidthConstraint.isActive = true
        } else {
            
            // update
            containerViewWidthConstraint.constant = screenWidth
        }
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


// MARK: Methods to adapt the view to portrait/landscape
extension MovieDetailsView {
    
    func setPortraitMode() {
        
        deactivateLandscapeMode()
        activatePortraitMode()
        updateCustomConstraints()
    }
    
    func setLandscapeMode() {
        
        deactivatePortraitMode()
        activateLandscapeMode()
        updateCustomConstraints()
    }
    
    private func activatePortraitMode() {
        
        for contraint in constraintsPortrait {
            
            contraint.isActive = true
        }
    }
    
    private func deactivatePortraitMode() {
    
        for contraint in constraintsPortrait {
            
            contraint.isActive = false
        }
    }
    
    private func activateLandscapeMode() {

        for contraint in constraintsLandscape {
            
            contraint.isActive = true
        }
    }
    
    private func deactivateLandscapeMode() {
        
        for contraint in constraintsLandscape {
            
            contraint.isActive = false
        }
    }
}
