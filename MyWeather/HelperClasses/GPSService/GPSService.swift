//
//  GPSService.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation
import CoreLocation

protocol GPSServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class GPSService: NSObject {
    
    static let sharedInstance: GPSService = {
        let instance = GPSService()
        return instance
    }()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: GPSServiceDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else { return }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            //locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        // The accuracy of the location data
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.distanceFilter = 200
        locationManager.delegate = self
    }
    
    static func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default: break
            }
        } else {
            // Location services are not enabled
            return false
        }
        return false
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
}

extension GPSService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        print(location)
        
        // Singleton for get last(current) location
        currentLocation = location
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    fileprivate func updateLocation(currentLocation: CLLocation) {
        guard let delegate = self.delegate else { return }
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    fileprivate func updateLocationDidFailWithError(error: NSError) {
        guard let delegate = self.delegate else { return }
        delegate.tracingLocationDidFailWithError(error: error)
    }
}
