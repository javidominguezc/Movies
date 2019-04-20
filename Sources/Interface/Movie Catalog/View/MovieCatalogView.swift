//
//  MovieCatalogView.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

class MovieCatalogView: SimpleView {
    
    // MARK: Private
    private struct ViewTraits {

        // Margins
        static let topMargin: CGFloat = 15.0
        static let bottomMargin: CGFloat = 50.0

        //Heights
        static let viewHeight: CGFloat = 150.0
    }

    // MARK: Public
    let tableView: UITableView

    override init(frame: CGRect) {
        
        //tableView
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear

        // Init
        super.init(frame: frame)

        backgroundColor = .white

        // Add subviews
        addSubview(tableView)

        // Add constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addCustomConstraints()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomConstraints() {

        NSLayoutConstraint.activate([

            // Horizontal
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Vertical
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

}

// MARK: Methods to show and hide the table view
extension MovieCatalogView {
    
    func showTableView() {
        
        tableView.isHidden = false
    }
    
    func hideTableView() {
        
        tableView.isHidden = true
    }
}
