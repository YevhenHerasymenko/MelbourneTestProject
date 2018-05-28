//
//  StubSubscriber.swift
//  MelbourneTestProjectCoreTests
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import XCTest
import ReSwift

class StubSubscriber<T>: ReSwift.StoreSubscriber {
    typealias StoreSubscriberStateType = T
    let promise: XCTestExpectation
    let promiseTrigger: (T) -> Bool
    
    init(promise: XCTestExpectation, promiseTrigger: @escaping (T) -> Bool) {
        self.promise = promise
        self.promiseTrigger = promiseTrigger
    }
    
    func newState(state: T) {
        if promiseTrigger(state) {
            promise.fulfill()
        }
    }
}
