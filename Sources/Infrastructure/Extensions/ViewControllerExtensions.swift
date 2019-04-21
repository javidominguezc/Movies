//
//  ViewControllerExtensions.swift
//  Movies
//
//  Created by Javier Dominguez on 21/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // show an alert with the error and action to retry
    func showError(description: String?, _ action: (() -> Void)?) {
        
        var errorDescription = description
        
        if errorDescription == nil {
            
            errorDescription = NSLocalizedString("Error - Friendly message", comment: String(describing: self))
        }
        
        let title = NSLocalizedString("General error - title", comment: String(describing: self))
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        
        presentAlert(alert: alert, action: action)
    }
    
    // show no internet connection alert
    func showNoInternectConnectionAlert(specialFeature: Bool = false, _ action: (() -> Void)?) {
    
        let title = NSLocalizedString("No internet - title", comment: String(describing: self))
        var message = NSLocalizedString("No internet - message", comment: String(describing: self))
        
        if specialFeature {
            message = NSLocalizedString("No internet for feature - message", comment: String(describing: self))
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        presentAlert(alert: alert, action: action)
    }
    
    private func presentAlert(alert: UIAlertController, action: (() -> Void)?) {
    
        if let action = action {
            let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "dismiss"), style: .cancel, handler: nil)
            
            let retryAction = UIAlertAction(title: NSLocalizedString("Retry", comment: "retry"), style: .default, handler: {( _) in
                
                action()
            })
            alert.addAction(retryAction)
            alert.addAction(dismissAction)
        } else {
            
            let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: String(describing: self)),
                                         style: .default,
                                         handler: nil)
            alert.addAction(okAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
}
