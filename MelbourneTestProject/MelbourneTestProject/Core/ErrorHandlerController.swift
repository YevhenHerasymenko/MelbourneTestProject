//
//  ErrorHandlerController.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/29/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import UIKit

struct ErrorModel {
    let title: String?
    let message: String?
}

struct AlertAction {
    let title: String
    let style: UIAlertActionStyle
    let action: (() -> Void)?
}

/**
 ErrorHandlerController is specific protocol for view controller to show that current controller can show error alerts
 */
protocol ErrorHandlerController {
    func showError(model: ErrorModel, completion: (() -> Void)?)
}

extension ErrorHandlerController where Self: UIViewController {
    
    func showError(model: ErrorModel, completion: (() -> Void)?) {
        showAlert(title: model.title, message: model.message, completion: completion)
    }
    
    private func showAlert(title: String?,
                           message: String?,
                           completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: NSLocalizedString("Ok", comment: "Ok"),
            style: .default,
            handler: nil
        )
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
    
}
