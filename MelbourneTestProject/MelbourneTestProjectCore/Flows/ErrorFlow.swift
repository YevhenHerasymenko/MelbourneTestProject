//
//  ErrorFlow.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import ReSwift

/// Error flow
public struct ErrorFlow {
    
    /// State
    public struct State: StateType {
        /// error value
        public var error: NetworkError?
    }
    
    enum Reducer {}
}

/// Actions mutate state
extension ErrorFlow {
    enum Actions: ReSwift.Action {
        case setError(NetworkError?)
    }
}

/// Reducer, mutate state
extension ErrorFlow.Reducer {
    
    static func handleAction(action: ReSwift.Action, state: ErrorFlow.State?) -> ErrorFlow.State {
        var state = state ?? ErrorFlow.State()
        guard let action = action as? ErrorFlow.Actions else {
            return state
        }
        switch action {
        case .setError(let error):
            state.error = error
        }
        return state
    }
    
}

/// Action Creators
extension ErrorFlow {
    
    /// public action from removing error when it was handled
    public static func resetError() -> ReSwift.Store<AppState>.ActionCreator {
        return { state, store in
            return Actions.setError(nil)
        }
    }
    
}
