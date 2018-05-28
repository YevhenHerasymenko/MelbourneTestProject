//
//  NetworkError.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import ObjectMapper

/// List of network errors
public enum NetworkError: Error {
    /// no internet
    case noInternetConnection
    /// timeout (time can be different for different requests)
    case timeout
    /// unexpected response
    case badResponse
    /// error during generation app model from server response (JSON)
    case parsingError
    /// the others cases
    case unknown
}
