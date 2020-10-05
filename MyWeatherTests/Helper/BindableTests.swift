//
//  BindableTests.swift
//  MyWeatherTests
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import XCTest
@testable import MyWeather

class BindableTests: XCTestCase {
    
    func testBind() {
        let bindable = Bindable(false)
        let expectListenerCalled = expectation(description: "Listener is called")
        bindable.bind { value in
            XCTAssert(value == true, "testBind failed, should have been true")
            expectListenerCalled.fulfill()
        }
        bindable.value = true
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testBindAndFire() {
        let bindable = Bindable(true)
        let expectListenerCalled = expectation(description: "Listener is called")
        bindable.bindAndFire { value in
            XCTAssert(value == true, "testBindAndFire failed, should have been true")
            expectListenerCalled.fulfill()
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
}
