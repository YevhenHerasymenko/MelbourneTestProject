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
            .responseJSON { response in
                switch response.result {
                case .success(let result):
                    guard let resultDictionary = result as? [String: AnyObject] else {
                        resultCallback(NetworkResult<T>.failure(.badResponse))
                        return
                    }
                    do {
                        let object = try Mapper<T>().map(JSON: resultDictionary)
                        resultCallback(NetworkResult<T>.success(object))
                    } catch {
                        resultCallback(NetworkResult<T>.failure(.parsingError(resultDictionary)))
                    }
                case .failure(let error):
                    resultCallback(NetworkResult<T>.failure(SessionManager.parse(error: error, with: response)))
                }
        }
    }
    
    func perform<T: ImmutableMappable>(request value: NetworkRouting,
                                       resultCallback: @escaping (NetworkResult<[T]>) -> Void) {
        request(value)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let result):
                    guard let resultDictionary = result as? [[String: AnyObject]] else {
                        resultCallback(NetworkResult<[T]>.failure(.badResponse))
                        return
                    }
                    do {
                        let object = try Mapper<T>().mapArray(JSONArray: resultDictionary)
                        resultCallback(NetworkResult<[T]>.success(object))
                    } catch {
                        resultCallback(NetworkResult<[T]>.failure(.parsingError(resultDictionary)))
                    }
                case .failure(let error):
                    resultCallback(NetworkResult<[T]>.failure(SessionManager.parse(error: error, with: response)))
                }
        }
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
