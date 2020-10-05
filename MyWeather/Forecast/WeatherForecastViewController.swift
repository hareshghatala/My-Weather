//
//  WeatherForecastViewController.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherForecastViewController: UIViewController {
    
    @IBOutlet weak var imgThemeWeather: UIImageView!
    @IBOutlet weak var lblCurrentTempDesc: UILabel!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        }
    }
    @IBOutlet weak var alertOverlayView: UIView! {
        didSet {
            self.alertOverlayView.isHidden = true
        }
    }
    @IBOutlet weak var lblAlertTitle: UILabel!
    @IBOutlet weak var lblAlertMessage: UILabel!
    
    let todayViewModel: TodayWeatherViewModel = TodayWeatherViewModel()
    let weeklyViewModel: WeeklyDataTableViewModel = WeeklyDataTableViewModel()
    
    // MARK:- Viewcontroller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindWeeklyViewModel()
        bindTodayViewModel()
        checkLocationAndConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getWeatherData), name: .getWeatherData, object: nil)
        self.getWeatherData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .getWeatherData, object: nil)
    }
    
    // MARK:- Checking location service and Network connection
    
    private func checkLocationAndConnection() {
        if !Reachability.isConnectedToNetwork() {
            self.showInternetAlertOverlay()
        } else if !GPSService.isLocationServiceEnabled() {
            self.showLocationAlertOverlay()
        } else {
            self.alertOverlayView.isHidden = true
        }
    }
    
    private func showInternetAlertOverlay() {
        self.lblAlertTitle.text = "No network connect"
        self.lblAlertMessage.text = "Could not connect to the network, failed to update information. Please make sure you are connected to the network."
        self.alertOverlayView.isHidden = false
    }
    
    private func showLocationAlertOverlay() {
        self.lblAlertTitle.text = "Could not find location"
        self.lblAlertMessage.text = "Please enable location service for the app in device settings and try again."
        self.alertOverlayView.isHidden = false
    }
    
    @IBAction private func alertTryAgainTapAction(_ sender: UIButton) {
        self.getWeatherData()
    }
    
    // MARK:- Fetch weather data
    
    /// Fetching weather info
    @objc func getWeatherData() {
        delay(delay: 0.2) {
            if Reachability.isConnectedToNetwork() {
                if let location = GPSService.sharedInstance.currentLocation {
                    self.alertOverlayView.isHidden = true
                    SharedClass.sharedInstance.isLocationReceived = true
                    self.UpdateWeatherData(location: location)
                } else {
                    self.showLocationAlertOverlay()
                }
            } else {
                self.showInternetAlertOverlay()
            }
        }
    }
    
    /// API hit and update weather data
    func UpdateWeatherData(location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        DispatchQueue.once {
            weeklyViewModel.getWeeklyData(params: [("lat", "\(lat)"), ("lon", "\(lon)")])
            todayViewModel.getCurrentWeatherData(params: [("lat", "\(lat)"), ("lon", "\(lon)")])
        }
    }
    
    // MARK:- Private helper methods
    
    /// Bind  current/today forecast view model
    private func bindTodayViewModel() {
        todayViewModel.minTemp.bindAndFire { [weak self] minTemp in
            self?.lblMinTemp.text = minTemp
        }
        todayViewModel.currentTemp.bindAndFire { [weak self] currentTemp in
            self?.lblCurrentTemp.text = currentTemp
        }
        todayViewModel.maxTemp.bindAndFire { [weak self] maxTemp in
            self?.lblMaxTemp.text = maxTemp
        }
        todayViewModel.description.bindAndFire { [weak self] description in
            self?.view.backgroundColor = SharedClass.sharedInstance.getWeatherThemeColor(name: description)
            self?.imgThemeWeather.image = SharedClass.sharedInstance.getWeatherImage(name: description)
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal(text: (self?.lblCurrentTemp.text?.components(separatedBy: " ").first)!,font: UIFont(name: "Verdana-Bold", size: 50)!)
                .bold(text: " \(description)",font: UIFont(name: "Verdana", size: 34)!)
            self?.lblCurrentTempDesc.attributedText = formattedString
        }
//        todayViewModel.showLoadingHud.bind() { visible in
//            print("Today Loading Hud \(visible)")
//            visible ? SharedClass.sharedInstance.showLoader(strTitle: "") : SharedClass.sharedInstance.dismissLoader()
//        }
        
        todayViewModel.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
    }
    
    /// Bind weekly forecast view model
    func bindWeeklyViewModel() {
        weeklyViewModel.dayWiseForcating.bindAndFire() { [weak self] _ in
            self?.tableView?.reloadData()
        }
        weeklyViewModel.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
        weeklyViewModel.showLoadingHud.bind() { visible in
            print("Weekly Loading Hud \(visible)")
            visible ? SharedClass.sharedInstance.showLoader(strTitle: "") : SharedClass.sharedInstance.dismissLoader()
        }
    }
    
}
