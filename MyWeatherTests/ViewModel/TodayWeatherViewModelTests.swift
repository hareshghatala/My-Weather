//
//  TodayWeatherViewModelTests.swift
//  MyWeatherTests
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import XCTest

@testable import MyWeather

class TodayWeatherViewModelTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()

    func testForCurrentWeatherSuccess() {
        do {
            let todayWeather = try jsonDecoder.decode(TodayWeather.self, from: Data.init())
            let appServerClient = MockAppServerClient()
            appServerClient.daillyResult = .success(payload:todayWeather)
    
            let viewModel = TodayWeatherViewModel(appServerClient: appServerClient)
            viewModel.getCurrentWeatherData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
        
            XCTAssertNotNil(viewModel.currentTemp, "Current temperature not found")
            XCTAssertNotNil(viewModel.description, "Description not found")
            XCTAssertNotNil(viewModel.minTemp, "Minimum temperature not found")
            XCTAssertNotNil(viewModel.maxTemp,"Maximum temperature not found")
        }
        catch {}
    }
    
    func testForCurrentWeatherFailure() {
        let appServerClient = MockAppServerClient()
        appServerClient.daillyResult = .failure(nil)
        let viewModel = TodayWeatherViewModel(appServerClient: appServerClient)
        viewModel.getCurrentWeatherData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
        viewModel.onShowError = { error in
          XCTAssertNotNil(error)
        }
    }
    
    private final class MockAppServerClient: AppServerClient {
        var daillyResult: AppServerClient.TodayResult?
        override func getTodayWeather(params: [(String, String)], completion: @escaping AppServerClient.TodayResultCompletion) {
            completion(daillyResult!)
        }
    }
}
