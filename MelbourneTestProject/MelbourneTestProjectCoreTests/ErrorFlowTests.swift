//
//  ErrorFlowTests.swift
//  MelbourneTestProjectCoreTests
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import XCTest
@testable import MelbourneTestProjectCore
import ReSwift

class ErrorFlowTests: XCTestCase {
    
    var store: MelbourneTestProjectCore.Store<AppState>!
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        store = MelbourneTestProjectCore.Store<AppState>(
            reducer: AppState.appReducer,
            state: nil)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSetError() {
        set(error: .noInternetConnection)
        XCTAssertNotNil(store.state.errorState.error)
        guard case .noInternetConnection = store.state.errorState.error! else {
            XCTFail("Wrong error")
            return
        }
    }
    
    func testResetError() {
        set(error: .noInternetConnection)
        XCTAssertNotNil(store.state.errorState.error)
        let promise = expectation(description: #function)
        promise.assertForOverFulfill = false
        let stubSubscriber = StubSubscriber<AppState>(promise: promise) { _ in
            return self.store.state.errorState.error == nil
        }
        store.subscribe(stubSubscriber)
        store.dispatch(ErrorFlow.resetError())
        waitForExpectations(timeout: 5, handler: nil)
        store.unsubscribe(stubSubscriber)
        
        XCTAssertNil(store.state.errorState.error)
    }
    
    private func set(error: NetworkError) {
        let promise = expectation(description: #function)
        promise.assertForOverFulfill = false
        let stubSubscriber = StubSubscriber<AppState>(promise: promise) { _ in
            return self.store.state.errorState.error != nil
        }
        store.subscribe(stubSubscriber)
        store.dispatch(ErrorFlow.Actions.setError(error))
        waitForExpectations(timeout: 5, handler: nil)
        store.unsubscribe(stubSubscriber)
    }
}

