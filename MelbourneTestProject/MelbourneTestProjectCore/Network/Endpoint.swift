//
//  Endpoint.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import Alamofire

enum Endpoints: NetworkRouting {
    case facts
    
    var method: HTTPMethod {
        switch self {
        case .facts:
            return .get
        }
    }
    
    var path: String {
        let baseURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl"
        switch self {
        case .facts:
            return baseURL / "facts.json"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
}
