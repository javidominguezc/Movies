//
//  SimpleView.swift
//  Movies
//
//  Created by Javier Dominguez on 19/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit
import JGProgressHUD

class SimpleView: UIView {
    
    var contentView: UILayoutGuide = UILayoutGuide()
    let hud: JGProgressHUD
    
    override init(frame: CGRect) {
        
        hud = JGProgressHUD(style: .dark)
        
        // Init
        super.init(frame: frame)
        
        hud.textLabel.text = NSLocalizedString("Loading content", comment: "")
        
        setContenView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setContenView() {
        
        if #available(iOS 11.0, *) {
            
            contentView = safeAreaLayoutGuide
        } else {
            
            addLayoutGuide(contentView)
            let standardSpacing: CGFloat = 20.0
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: topAnchor, constant: standardSpacing),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
        }
    }
}

// MARK: Extension - Spinner indicator controls
extension SimpleView {
    
    func showLoadingIndicator() {
    
        hud.show(in: self, animated: true)
    }
    
    func hideLoadingIndicator() {
        
        hud.dismiss(animated: true)
    }
}
