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
        loading.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationPermission()
    }
    
    func checkLocationPermission() {
        let permissionStatus = CLLocationManager.authorizationStatus()
        switch permissionStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .restricted, .denied:
            showAlert(withMessage: "Please turn on location permission in settings")
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
        loading.startAnimating()

        updateLocation()
    }
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }

    func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.updateLocation() }))
        self.present(alert, animated: true)
    }

}

extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let location = locations.first else { return }
        let long = "\(location.coordinate.longitude)"
        let lat = "\(location.coordinate.latitude)"
        
        loading.startAnimating()
        weatherModel.getCurrentWeatherFor(latitude: lat, longitude: long, successCompletionHandler: { () in
            self.tempLabel.text = "\(Int(self.weatherModel.weatherData.main.temp.rounded())) ºF"
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }, failCompletionHandler: { (MoyaError) in
            self.showAlert(withMessage: MoyaError.localizedDescription)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ((status == .restricted) || (status == .denied)) {
            showAlert(withMessage: "Please turn on location permission in settings")
        } else {
            locationManager.startUpdatingLocation()
        }
    }
}

