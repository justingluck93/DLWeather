//
//  WeatherModel.swift
//  DLWeather
//
//  Created by JustinCaty<3 on 3/5/19.
//  Copyright © 2019 DL. All rights reserved.
//

import Foundation
import Moya

class WeatherModel {
    let apiKey = "d78bc971defb9c9c6d281dde9d133a02"
    let provider = MoyaProvider<WeatherServices>()
    var weatherData: WeatherResults!
    
    func getCurrentWeatherFor(latitude: String, longitude: String,  successCompletionHandler: @escaping () -> ()) {
        provider.request(.currentLocationOneDayForcast(apiKey: apiKey, latitude: latitude, longitude: longitude)) { (result) in
            switch result {
            case .success(let response):
                do {
                    self.weatherData = try JSONDecoder().decode(WeatherResults.self, from: response.data)
                    successCompletionHandler()
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct WeatherResults: Decodable {
    var main: Main
}

struct Main: Decodable {
    var temp: Double
}

