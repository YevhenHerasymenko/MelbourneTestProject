//
//  FactsFlow.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import ReSwift

public enum FactsFlow {
    
    public struct State: ReSwift.StateType {
        
        var factsGroup: FactsGroup?
    }
    
    enum Reducer {}
}

extension FactsFlow {
    enum Actions: ReSwift.Action {
        case setFacts(FactsGroup?)
    }
}

extension FactsFlow.Reducer {
    
    static func handleAction(action: ReSwift.Action, state: FactsFlow.State?) -> FactsFlow.State {
        var state = state ?? FactsFlow.State()
        guard let action = action as? FactsFlow.Actions else {
            return state
        }
        switch action {
        case .setFacts(let facts):
            state.factsGroup = facts
        }
        return state
    }
    
}

/// Action Creators, state mutation
extension FactsFlow {
    
    /// perform login api call and fetching initial data
    public static func factsSync() -> ReSwift.Store<AppState>.ActionCreator {
        return { state, store in
            store.dispatch(performLoadingFacts())
            return nil
        }
    }
    
    static func performLoadingFacts() -> ReSwift.Store<AppState>.AsyncActionCreator {
        return { state, store, callback in
            guard let store = store as? Store else {
                fatalError()
            }
            let request = Endpoints.facts
            store.sessionManager.perform(request: request) { (result: NetworkResult<FactsGroup>) in
                switch result {
                case .success(let factsGroup):
                    callback(set(facts: factsGroup))
                case .failure(let error):
                    store.dispatch(interaptLoadingFacts(reason: error))
                }
            }
        }
    }
    
    /// store facts
    static func set(facts: FactsGroup?) -> ReSwift.Store<AppState>.ActionCreator {
        return { state, store in
            store.dispatch(Actions.setFacts(facts))
            return nil
        }
    }

    static func interaptLoadingFacts(reason error: NetworkError) -> ReSwift.Store<AppState>.ActionCreator {
        return { state, store in
            return ErrorFlow.Actions.setError(error)
        }
    }
    
}
