//
//  WeatherTableViewCell.swift
//  DLWeather
//
//  Created by JustinCaty<3 on 3/8/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    var imageDict = [String : UIImage?]()

    func setUpWeatherCell(withIconID id: String, temperature temp: String, date: Double) {
        self.date.text = getDateFromEpoch(date: date)
        self.temp.text = temp
        self.getImageFromUrl(iconIdentifier: id)
    }

    func getImageFromUrl(iconIdentifier: String){
        guard let iconURL = URL(string: "https://openweathermap.org/img/w/\(iconIdentifier).png"),
            let data = try? Data(contentsOf:iconURL) else { fatalError() }
        self.weatherImage.image = UIImage(data: data)
    }
    
    func getDateFromEpoch(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d E h:mm"
        
        return dateFormatter.string(from: date)
    }
}
