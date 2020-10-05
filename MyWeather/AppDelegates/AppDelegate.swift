//
//  AppDelegate.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/04.
//  Copyright © 2020 Haresh. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(2) //for delaying launch screen
        let locationInstance = GPSService.sharedInstance
        locationInstance.delegate = self
        locationInstance.startUpdatingLocation()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: GPSServiceDelegate {
    
    func tracingLocation(currentLocation: CLLocation) {
        print(currentLocation)
        if !SharedClass.sharedInstance.isLocationReceived {
            NotificationCenter.default.post(name: .getWeatherData, object: nil, userInfo: nil)
            SharedClass.sharedInstance.isLocationReceived = true
        }
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print(error.localizedDescription)
    }
    
}
