//
//  MockSessionManager.swift
//  MelbourneTestProjectCoreTests
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

@testable import MelbourneTestProjectCore
import Foundation
import XCTest
import ObjectMapper

enum MockFile: String {
    // login mocks
    case successLogin
    case failedLogin
    // channel mocks
    case channelsList
    case channelStreams
    case failedLoadChannel
    // empty response
    case empty
}

struct MockRouting {
    enum Result {
        case success(fileName: MockFile)
        case serverError(fileName: MockFile)
        case customError(NetworkError)
    }
    
    let routing: NetworkRouting
    let result: Result
    
    func isEqualTo(otherRouting: NetworkRouting) -> Bool {
        switch (routing, otherRouting) {
//        case :
//            return true
        default:
            return false
        }
    }
}

class MockSessionManagerBuilder: NetworkSessionManagerBuilder {
    let sessionManager: NetworkSessionManager
    
    init(manager: NetworkSessionManager) {
        sessionManager = manager
    }
    
    func createSessionManager() -> NetworkSessionManager {
        return sessionManager
    }
    
}

class MockSessionManager: NetworkSessionManager {
    let scenarios: [MockRouting]
    init(scenarios: [MockRouting]) {
        self.scenarios = scenarios
    }
    
    func perform<T: ImmutableMappable>(request value: NetworkRouting,
                                       resultCallback: @escaping (NetworkResult<T>) -> Void) {
        guard let request = try? value.asURLRequest() else {
            XCTFail("can't construct request")
            return
        }
        guard let scenario = scenarios.first(where: { $0.isEqualTo(otherRouting: value) }) else {
            XCTFail("can't find scenario for requset: \(request)")
            return
        }
        DispatchQueue.main.async {
            switch scenario.result {
            case .success(let fileName):
                do {
                    let json = self.loadObject(from: fileName)
                    let object = try Mapper<T>().map(JSON: json)
                    resultCallback(NetworkResult<T>.success(object))
                } catch {
                    XCTFail("can't parse response for: \(fileName.rawValue)")
                }
            case .serverError(let fileName):
                resultCallback(NetworkResult<T>.failure(.parsingError(fileName.rawValue)))
            case .customError(let error):
                resultCallback(NetworkResult<T>.failure(error))
            }
        }
    }
    
    func perform<T: ImmutableMappable>(request value: NetworkRouting,
                                       resultCallback: @escaping (NetworkResult<[T]>) -> Void) {
        guard let request = try? value.asURLRequest() else {
            XCTFail("can't construct request")
            return
        }
        guard let scenario = scenarios.first(where: { $0.isEqualTo(otherRouting: value) }) else {
            XCTFail("can't find scenario for requset: \(request)")
            return
        }
        DispatchQueue.main.async {
            switch scenario.result {
            case .success(let fileName):
                do {
                    let json = self.loadObjectArray(from: fileName)
                    let object = try Mapper<T>().mapArray(JSONArray: json)
                    resultCallback(NetworkResult<[T]>.success(object))
                } catch {
                    XCTFail("can't parse response for: \(fileName.rawValue)")
                }
            case .serverError(let fileName):
                resultCallback(NetworkResult<[T]>.failure(.parsingError(fileName.rawValue)))
            case .customError(let error):
                resultCallback(NetworkResult<[T]>.failure(error))
            }
        }
    }
    
    private func loadObject(from file: MockFile) -> [String: AnyObject] {
        guard let dataURL = Bundle(for: type(of: self)).url(forResource: file.rawValue, withExtension: "json"),
            let data = try? Data(contentsOf: dataURL) else {
                XCTFail("can't load data from file: \(file.rawValue)")
                return [:]
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = json as? [String: AnyObject] else {
                XCTFail("can't parse json from file: \(file.rawValue)")
                return [:]
        }
        return dict
    }
    
    private func loadObjectArray(from file: MockFile) -> [[String: AnyObject]] {
        guard let dataURL = Bundle(for: type(of: self)).url(forResource: file.rawValue, withExtension: "json"),
            let data = try? Data(contentsOf: dataURL) else {
                XCTFail("can't load data from file: \(file.rawValue)")
                return []
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = json as? [[String: AnyObject]] else {
                XCTFail("can't parse json from file: \(file.rawValue)")
                return []
        }
        return dict
    }
    
}
