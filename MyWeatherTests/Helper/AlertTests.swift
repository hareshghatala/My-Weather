//
//  AlertTests.swift
//  MyWeatherTests
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import XCTest
@testable import MyWeather

class AlertTests: XCTestCase {
    
    func testAlert() {
        let expectAlertActionHandlerCall = expectation(description: "Alert action handler called")
        let alert = SingleButtonAlert(
            title: "",
            message: "",
            action: AlertAction(buttonTitle: "", handler: {
                expectAlertActionHandlerCall.fulfill()
            })
        )
        alert.action.handler!()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
