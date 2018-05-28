//
//  ViewControllerModel.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import Foundation

/// Protocol for view controler models that shows that model should be Equatable
protocol ViewControllerModel: Equatable {}

/** Additional protocol that can be used in ViewControllerModel realization and shows
 that model provides info about error
 */
protocol HasError {
    // error value
    var error: String? { get }
}

/**
 Protocol for showing that view controller contains model property and that property is ViewControllerModel
 */
protocol ViewControllerModelSupport {
    // type for model
    associatedtype ModelType: ViewControllerModel
    // model variable
    var model: ModelType? { get set }
    // method is used when handle state updates for rendering new model
    func render(_ model: ModelType)
}

extension ViewControllerModelSupport {
    
    func render(_ model: ModelType) {}
    
}
