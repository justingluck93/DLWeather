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
    var futureWeatherData: FiveDayWeatherForcast!
    
    func getCurrentWeatherFor(latitude: String, longitude: String,  successCompletionHandler: @escaping () -> (), failCompletionHandler: @escaping (MoyaError) -> ()) {
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
               failCompletionHandler(error)
            }
        }
    }
    
    func getFutureWeatherFor(latitude: String, longitude: String,  successCompletionHandler: @escaping () -> (), failCompletionHandler: @escaping (MoyaError) -> ()) {
        provider.request(.currentLocationFiveDayForcast(apiKey: apiKey, latitude: latitude, longitude: longitude)) { (result) in
            switch result {
            case .success(let response):
                do {
                    print(response.data)
                    self.futureWeatherData = try JSONDecoder().decode(FiveDayWeatherForcast.self, from: response.data)
                    print(self.futureWeatherData)
                    successCompletionHandler()
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                failCompletionHandler(error)
            }
        }
    }
}

//Current Weather
struct WeatherResults: Decodable {
    var main: Main
}

//Common
struct Main: Decodable {
    var temp: Double
}

// 5 Day Future Weather
struct FiveDayWeatherForcast: Decodable {
    var list: [ThreeHourInterval]
    var city: City
}

struct ThreeHourInterval: Decodable {
    var dt: Double
    var main: Main
    var weather: [Weather]
}

struct City: Decodable {
    var name: String
}

struct Weather: Decodable {
    var icon: String
}
