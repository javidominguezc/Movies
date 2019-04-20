//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

class MovieDetailsView: SimpleView {

    private struct ViewTraits {

        // Margins
        static let topMargin: CGFloat = 15.0
        static let bottomMargin: CGFloat = 50.0

        //Heights
        static let viewHeight: CGFloat = 150.0
    }

    // MARK: Public
    //let simpleView: UIView

    override init(frame: CGRect) {

        //simpleView
//        simpleView = UIView()
//        simpleView.backgroundColor = .clear

        // Init
        super.init(frame: frame)

        backgroundColor = .red

        // Add subviews
        //addSubview(simpleView)

        // Add constraints
        //simpleView.translatesAutoresizingMaskIntoConstraints = false

        addCustomConstraints()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomConstraints() {

        NSLayoutConstraint.activate([

            // Horizontal
            // Remember to use safeAreaLayoutGuide if iOS 11 and up
//            simpleView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            simpleView.trailingAnchor.constraint(equalTo: trailingAnchor),
//
//            // Vertical
//            simpleView.topAnchor.constraint(equalTo: topAnchor),
//            simpleView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
