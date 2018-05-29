//
//  AppState.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import ReSwift

/// Struct for saving app data during launching
public struct AppState: StateType {

    public var factsState: FactsFlow.State
    /// State for keeping error information
    public var errorState: ErrorFlow.State
    /// List of available general actions
    enum Actions: ReSwift.Action {
        /// action for clear whole data in app state
        case clearState
    }
}

extension AppState {
    
    static func appReducer(action: Action, state: AppState?) -> AppState {
        switch action {
        case AppState.Actions.clearState:
            return AppState(
                factsState: FactsFlow.State(),
                errorState: ErrorFlow.State()
            )
        default:
            return AppState(
                factsState: FactsFlow.Reducer.handleAction(action: action, state: state?.factsState),
                errorState: ErrorFlow.Reducer.handleAction(action: action, state: state?.errorState)
            )
        }
    }
    
}
