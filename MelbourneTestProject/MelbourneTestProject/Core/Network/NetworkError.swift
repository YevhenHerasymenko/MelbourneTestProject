//
//  NetworkError.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import MelbourneTestProjectCore

extension Error {
    
    func asNetworkError() -> NetworkError {
        switch (self as NSError).code {
        case NSURLErrorNotConnectedToInternet:
            return .noInternetConnection
        case NSURLErrorTimedOut:
            return .timeout
        default:
            return .unknown
        }
    }
    
}
