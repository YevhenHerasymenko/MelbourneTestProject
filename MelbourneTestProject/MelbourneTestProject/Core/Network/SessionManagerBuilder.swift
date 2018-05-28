//
//  SessionManagerBuilder.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import MelbourneTestProjectCore

class SessionManagerBuilder: NetworkSessionManagerBuilder {
    
    func createSessionManager() -> NetworkSessionManager {
        return SessionManager()
    }
    
}
