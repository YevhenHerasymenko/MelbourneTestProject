//
//  StateTransformer.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import MelbourneTestProjectCore

/// Protocol for explanation how to create view controller state from app state
public protocol StateTransformer {
    /// The type of ViewControllers Model
    associatedtype ViewState
    
    /// Main function for transformation AppState to ViewState
    static func transform(_ state: AppState) -> ViewState
    /// Function for filtering same ViewStates
    static func filter(old: ViewState, new: ViewState) -> Bool
}

public extension StateTransformer {
    
    /// Default realization for filter
    public static func filter(old: ViewState, new: ViewState) -> Bool {
        return true
    }
    
}
