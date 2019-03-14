//
//  FutureWeatherViewController.swift
//  DLWeather
//
//  Created by JustinCaty<3 on 3/6/19.
//  Copyright © 2019 DL. All rights reserved.
//

import UIKit
import CoreLocation

class FutureWeatherViewController: UITableViewController {
    private var weatherModel = WeatherModel()
    var imageDict = [String : UIImage?]()
    var locationManager: CLLocationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    
    func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func convertDate(milliseconds: Double) -> String {
        let date = Date(timeIntervalSince1970: milliseconds)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d E h:mm"
        
        return dateFormatter.string(from: date)
    }
}

extension FutureWeatherViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weatherModel.futureWeatherData == nil  { return 0 }
        return weatherModel.futureWeatherData.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCellx", for: indexPath) as! WeatherTableViewCell
        let image = imageDict[weatherModel.futureWeatherData.list[indexPath.row].weather[0].icon]
        let imageID = weatherModel.futureWeatherData.list[indexPath.row].weather[0].icon
        
        if image == nil {
            self.getImageFromUrl(iconIdentifier:imageID)
        }
        if let myImage = imageDict[weatherModel.futureWeatherData.list[indexPath.row].weather[0].icon] {
            weatherCell.weatherImage.image = myImage
        }
      
        let cellTitle = Int(weatherModel.futureWeatherData.list[indexPath.row].main.temp.rounded())
        weatherCell.temp.text = "\(cellTitle) ºF"
        weatherCell.date.text = convertDate(milliseconds: weatherModel.futureWeatherData.list[indexPath.row].dt)

        return weatherCell
    }
    
    func getImageFromUrl(iconIdentifier: String){
        guard let iconURL = URL(string: "https://openweathermap.org/img/w/\(iconIdentifier).png"),
        let data = try? Data(contentsOf:iconURL) else { fatalError() }
        self.imageDict[iconIdentifier] = UIImage(data: data)
    }
}

extension FutureWeatherViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if weatherModel.futureWeatherData == nil  { fatalError() }
        indexPaths.forEach {
            let imageRef = weatherModel.futureWeatherData.list[$0.row].weather[0].icon
            self.getImageFromUrl(iconIdentifier:imageRef)
        }
    }
}

extension FutureWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let location = locations.first else { return }
        let long = "\(location.coordinate.longitude)"
        let lat = "\(location.coordinate.latitude)"
        
        weatherModel.getFutureWeatherFor(latitude: lat, longitude: long, successCompletionHandler: { () in
            self.tableView.reloadData()
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
