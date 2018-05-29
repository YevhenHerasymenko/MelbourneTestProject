//
//  SessionManager.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import Alamofire
import ObjectMapper
import MelbourneTestProjectCore

class SessionManager: Alamofire.SessionManager, NetworkSessionManager {
    
    convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        self.init(configuration: configuration)
        self.retrier = RequestRetrier()
    }
    
    func setRequest(adapter: MelbourneTestProjectCore.RequestAdapter) {
        guard let adapter = adapter as? Alamofire.RequestAdapter else {
            fatalError("Unsupportable adapter")
        }
        self.adapter = adapter
    }
    
    func perform<T: ImmutableMappable>(request value: NetworkRouting,
                                       resultCallback: @escaping (NetworkResult<T>) -> Void) {
        request(value)
            .validate(statusCode: 200..<300)
            .responseString(completionHandler: { (value) in
                switch value.result {
                case .success(let stringValue):
                    if let data = stringValue.data(using: .utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data)
                            guard let resultDictionary = json as? [String: AnyObject] else {
                                    resultCallback(NetworkResult<T>.failure(.parsingError(stringValue)))
                                    return
                            }
                            let object = try Mapper<T>().map(JSON: resultDictionary)
                            resultCallback(NetworkResult<T>.success(object))
                        } catch {
                            resultCallback(NetworkResult<T>.failure(.parsingError(error.localizedDescription)))
                        }
                    }
                case .failure(let error):
                    resultCallback(NetworkResult<T>.failure(.parsingError(error.localizedDescription)))
                }
                
            })
    }
    
    private static func parse(error: Error, with response: DataResponse<Any>) -> NetworkError {
        guard let responseData = response.data, !responseData.isEmpty else {
            return error.asNetworkError()
        }
        guard let json = try? JSONSerialization.jsonObject(with: responseData, options: []),
            let errorDict = json as? [String: AnyObject] else {
                return .badResponse
        }
        
        return .parsingError(errorDict)
    }
    
}
