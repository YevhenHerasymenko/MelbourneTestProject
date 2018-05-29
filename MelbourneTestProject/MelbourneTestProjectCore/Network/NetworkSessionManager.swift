//
//  NetworkSessionManager.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import Alamofire
import ObjectMapper

/**
 Builder for creation new network session manager
 */
public protocol NetworkSessionManagerBuilder {
    /// builder method, return NetworkSessionManager instance type
    func createSessionManager() -> NetworkSessionManager
}

/**
 Protocol for routers. Protocol expands URLRequestConvertible which Alamofire uses for requests with MockableRequest
 which allows profide mock files for testing
 */
public protocol NetworkRouting: URLRequestConvertible {}

/**
 Protocol for request which describe how each request should be prapared with specific credentials.
 */
public protocol RequestAdapter {}

/**
 Protocol describes basic functions for Session managers it provides opportunity to create specific session manager
 for unit testing or etc
 */
public protocol NetworkSessionManager {
    
    /// method for setting request adapter
    func setRequest(adapter: RequestAdapter)
    
    /// method for request with simple object in response
    func perform<T: ImmutableMappable>(request value: NetworkRouting,
                                       resultCallback: @escaping (NetworkResult<T>) -> Void)
    
}

extension NetworkSessionManager {
    
    func setRequest(adapter: RequestAdapter) {}
    
}

/// Network Result. Generic Enum for server response
public enum NetworkResult<T> {
    
    /// with generic type
    case success(T)
    
    /// case for errors in response
    case failure(NetworkError)
}
