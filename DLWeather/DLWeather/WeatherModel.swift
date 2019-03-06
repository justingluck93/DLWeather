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
   let provider = MoyaProvider<WeatherServices>()
    
    func getCurrentWeather() {
        
    }
  
    
}

struct WeatherResults: Decodable {
    var main: Main
}

struct Main: Decodable {
    var temp: Double
}

