//
//  CurrentWeatherViewController.swift
//  DLWeather
//
//  Created by JustinCaty<3 on 3/5/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var weatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
    }

    

}

