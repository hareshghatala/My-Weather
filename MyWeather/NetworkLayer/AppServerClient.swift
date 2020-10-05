//
//  AppServerClient.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation
import Alamofire

class AppServerClient {
    
    private struct Constants {
        static let APPID = "c31835f03478ebd1cbae98c64ae23ced"
        static let baseURL = "https://api.openweathermap.org/data/2.5/"
    }
    
    enum ResourcePath: String {
        case CurrentWeather = "weather"
        case Forecast = "forecast"
        
        var path: String {
            return Constants.baseURL + rawValue
        }
    }
    
    enum DataFailureReason: Int, Error {
        case invalidkey = 401
        case notFound = 404
    }
    
    static func setUrlPathComponent(url: URL, params: [(String, String)]) -> URLComponents {
        var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
        let keyQueryItem = URLQueryItem(name: "APPID", value: Constants.APPID)
        queryItems.append(keyQueryItem)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = queryItems
        return urlComponents
    }
    
    // MARK:- Current Weather
    
    typealias TodayResult = Result<TodayWeather, DataFailureReason>
    typealias TodayResultCompletion = (_ result: TodayResult) -> Void
    
    func getTodayWeather(params: [(String, String)], completion: @escaping TodayResultCompletion) {
        let urlComponent = AppServerClient.setUrlPathComponent(url: URL(string: ResourcePath.CurrentWeather.path)!, params: params)
        print((urlComponent.url?.absoluteString)!)
        
        Alamofire.request((urlComponent.url?.absoluteString)!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let jsonDecoder = JSONDecoder()
                    guard let currentWeather = try? jsonDecoder.decode(TodayWeather.self, from: response.data!) else {
                        completion(.failure(nil))
                        return
                    }
                    completion(.success(payload: currentWeather))
                    
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = DataFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
    
    // MARK:-  Weekly Weather
    
    typealias WeeklyResult = Result<WeeklyWeather, DataFailureReason>
    typealias WeeklyResultCompletion = (_ result: WeeklyResult) -> Void
    
    func getWeeklyDataOfFiveDays(params: [(String, String)], completion: @escaping WeeklyResultCompletion) {
        let urlComponent = AppServerClient.setUrlPathComponent(url: URL(string:ResourcePath.Forecast.path)!, params: params)
        print((urlComponent.url?.absoluteString)!)
        
        Alamofire.request((urlComponent.url?.absoluteString)!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let jsonDecoder = JSONDecoder()
                    guard let weeklyWeather = try? jsonDecoder.decode(WeeklyWeather.self, from: response.data!) else {
                        completion(.failure(nil))
                        return
                    }
                    completion(.success(payload: weeklyWeather))
                    
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = DataFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
    
}

/// Failur Message
extension AppServerClient.DataFailureReason {
    
    func getErrorMessage() -> String? {
        switch self {
        case .invalidkey:
            return "Invalid Key. Please try with valid key."
        case .notFound:
            return "API Key is missing. Please try again."
        }
    }
    
}
