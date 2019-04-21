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
        
    }

    // MARK: Public
    let tableView: UITableView

    override init(frame: CGRect) {
        
        //tableView
        tableView = UITableView(frame: .zero, style: .plain)

        // Init
        super.init(frame: frame)
        
        setupViews()
        addSubviews()
        addConstraints()
    }
    
    private func setupViews() {
        
        backgroundColor = .white
        
        setupTableView()
    }
    
    private func setupTableView() {
    
        tableView.backgroundColor = .clear
    }
    
    private func addSubviews() {
        
        // Add subviews
        addSubview(tableView)
    }
    
    private func addConstraints() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints
        addCustomConstraints()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    private func addCustomConstraints() {

        NSLayoutConstraint.activate([

            // Horizontal
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Vertical
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
