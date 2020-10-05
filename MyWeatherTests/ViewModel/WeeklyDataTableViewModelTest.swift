//
//  WeeklyDataTableViewModelTest.swift
//  MyWeatherTests
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import XCTest
@testable import MyWeather

class WeeklyDataTableViewModelTest: XCTestCase {
    let jsonDecoder = JSONDecoder()
    
    func testForNormalCells() {
        do {
            let weeklyWeather = try jsonDecoder.decode(WeeklyWeather.self, from: Data.init())
            let appServerClient = MockAppServerClient()
            appServerClient.weeklyeResult = .success(payload:weeklyWeather)
            let viewModel = WeeklyDataTableViewModel(appServerClient: appServerClient)
            viewModel.getWeeklyData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
            guard case .some(.normal(_)) = viewModel.dayWiseForcating.value.first else{
                XCTFail()
                return
            }
        }
        catch {}
    }
    
    func testEmptyCells() {
        do {
            let weeklyWeather = try jsonDecoder.decode(WeeklyWeather.self, from: Data.init())
            let appServerClient = MockAppServerClient()
            appServerClient.weeklyeResult = .success(payload:weeklyWeather)
            let viewModel = WeeklyDataTableViewModel(appServerClient: appServerClient)
            viewModel.getWeeklyData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
            guard case .some(.empty) = viewModel.dayWiseForcating.value.first else {
                XCTFail()
                return
            }
        }
        catch {}
    }
    
    func testErrorCells() {
        let appServerClient = MockAppServerClient()
        appServerClient.weeklyeResult = .failure(AppServerClient.DataFailureReason.notFound)
        let viewModel = WeeklyDataTableViewModel(appServerClient: appServerClient)
        viewModel.getWeeklyData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
        guard case .some(.error) = viewModel.dayWiseForcating.value.first else {
            XCTFail()
            return
        }
    }
    
    private final class MockAppServerClient: AppServerClient {
        var weeklyeResult: AppServerClient.WeeklyResult?
        override func getWeeklyDataOfFiveDays(params: [(String, String)], completion: @escaping AppServerClient.WeeklyResultCompletion) {
            completion(weeklyeResult!)
        }
    }
}
