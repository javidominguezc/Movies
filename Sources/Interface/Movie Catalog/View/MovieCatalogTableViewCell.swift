//
//  MovieCatalogTableViewCell.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation
import UIKit

class MovieCatalogTableViewCell: UITableViewCell {
    
    // MARK: - Private
    private struct ViewTraits {
        
        //Margins
        static let imageSizeProportion: CGFloat = 0.4
        static let leftMargin: CGFloat = 5.0
        static let rightMargin: CGFloat = 10.0
    }
    
    // MARK: - Public
    let titleLabel: UILabel
    let pictureView: UIImageView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        //title label
        titleLabel = UILabel()
        
        //picture view
        pictureView = UIImageView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        addSubviews()
        addConstraints()
    }
    
    private func setupViews() {
        
        selectionStyle = .none
        backgroundColor = .clear
        
        setupTitleView()
        setupPictureView()
    }
    
    private func setupTitleView() {
        
        titleLabel.textColor = Color.black
        titleLabel.textAlignment = .left
        titleLabel.font = Font.MoviesBold.medium
        titleLabel.numberOfLines = 3
    }
    
    private func setupPictureView() {
        
        pictureView.contentMode = .scaleAspectFill
        pictureView.clipsToBounds = true
    }
    
    private func addSubviews() {
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(pictureView)
    }
    
    private func addConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints
        addCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomConstraints() {
        
        NSLayoutConstraint.activate([
            
            // Horizontal
            
            // pictureView
            pictureView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pictureView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: ViewTraits.imageSizeProportion),
            
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: ViewTraits.leftMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewTraits.rightMargin),
            
            // Vertical
            
            // pictureView
            pictureView.topAnchor.constraint(equalTo: topAnchor),
            pictureView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // titleLabel
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

}

// MARK: - Other methods

extension MovieCatalogTableViewCell {
    
    func setImage(data: Data) {
        
        pictureView.isHidden = false
        pictureView.image = UIImage(data: data)
    }
    
    func setNoImage() {
        
        pictureView.isHidden = true
    }
}
