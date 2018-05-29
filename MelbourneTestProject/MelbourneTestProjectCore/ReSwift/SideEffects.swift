//
//  SideEffects.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import ReSwift
import Kingfisher

// MARK: - SessionManager

/**
 Bunch of actions for setup additional services into store
 */
public enum SideEffects {
    
    /**
     Method add network session builder to store because it is necessary to clear TLS session cache in case
     of wrong password or etc. only way to do it it's a create a new NSURLSession instance
     https://developer.apple.com/library/content/qa/qa1727/_index.html
     
     - parameter builder: builder for creating new session manager
     */
    public static func setupNetworkSessionBuilder(builder: NetworkSessionManagerBuilder)
        -> ReSwift.Store<AppState>.ActionCreator {
            return { state, store in
                let store =  store as? Store<AppState>
                store?.networkSessionManagerBuilder = builder
                store?.sessionManager = builder.createSessionManager()
                return nil
            }
    }
    
}
