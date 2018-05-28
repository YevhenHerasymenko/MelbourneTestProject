//
//  Store.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import ReSwift

/**
 Subclass for ReSwift.Store which ppovides more flexible way for configuration side effects to FLUX architecture.
 It gives opportunity not use singletong for different managers
 */
class Store<State: StateType>: ReSwift.Store<State> {
    private var networkSessionManager: NetworkSessionManager?
    var networkSessionManagerBuilder: NetworkSessionManagerBuilder?
    
    var sessionManager: NetworkSessionManager {
        get {
            guard let manager = networkSessionManager else {
                fatalError("Network manager is not configured")
            }
            return manager
        } set {
            networkSessionManager = newValue
        }
    }
}

/// Public store for dispatching actions in application
public let mainStore: ReSwift.Store<AppState> = Store<AppState>(
    reducer: AppState.appReducer,
    state: nil)
