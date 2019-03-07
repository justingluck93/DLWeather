//
//  CurrentWeatherViewController.swift
//  DLWeather
//
//  Created by JustinCaty<3 on 3/5/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var weatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        loading.isHidden = true
    
        checkLocationPermission()
    }

    func checkLocationPermission() {
        let permissionStatus = CLLocationManager.authorizationStatus()
        switch permissionStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .restricted, .denied:
            showPermissionAlert()
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
        loading.startAnimating()

        locationManager.startUpdatingLocation()
    }

    func showPermissionAlert() {
        let alert = UIAlertController(title: "Permission Denied", message: "Please turn on location permission in settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showError() {
        
    }

}

extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        guard let location = locations.first else { return }
        let long = "\(location.coordinate.longitude)"
        let lat = "\(location.coordinate.latitude)"
        
        weatherModel.getCurrentWeatherFor(latitude: lat, longitude: long, successCompletionHandler: { () in
           self.tempLabel.text = "\(self.weatherModel.weatherData.main.temp) ºF"
            self.loading.stopAnimating()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ((status == .restricted) || (status == .denied)) {
            showPermissionAlert()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
}

