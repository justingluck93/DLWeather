//
//  WeatherServices.swift
//  DLWeather
//
//  Created by JustinCaty<3 on 3/5/19.
//  Copyright © 2019 DL. All rights reserved.
//

import Foundation
import Moya

enum WeatherServices {
    case currentLocationOneDayForcast(apiKey: String, latitude: String, longitude: String)
    case currentLocationFiveDayForcast
}

extension WeatherServices: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/")!
    }
    
    var path: String {
        switch self {
        case .currentLocationOneDayForcast(_):
            return "weather"
        case .currentLocationFiveDayForcast:
            return ""
        }
    }
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .currentLocationOneDayForcast(let apiKey, let latitude, let longitude):
            let params: [String: String] = ["lat": latitude, "lon": longitude, "apiKey": apiKey, "units": "imperial"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .currentLocationFiveDayForcast:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
