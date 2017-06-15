//
//  WeatherService.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

protocol WeatherServiceDelegate: class {
    func weatherDidUpdate(weather: WeatherModel)
    
    func forecastDidUpdate(weather: WeatherModel)

}


class WeatherService: NSObject {
    
    // Set your appid
    let appid: String
    weak var delegate: WeatherServiceDelegate?
    
    init(appid: String, delegate: WeatherServiceDelegate) {
        self.appid = appid
        self.delegate = delegate
    }
    
    /** Formats an API call to the OpenWeatherMap service. Pass in a CLLocation to retrieve weather data for that location.  */
    func getWeatherForLocation(location: CLLocation?) {
        
        guard let location = location else {
            return
        }
        
        let lat: Float = Float(location.coordinate.latitude)
        let lon: Float = Float(location.coordinate.longitude)
        
        APIService.getWeatherDataForLocation(lat: lat, lon: lon) { (weather, success) in
            if success {
                if let weather = weather {
                    self.delegate?.weatherDidUpdate(weather: weather)
                    return
                }
            }
        }
    }
}
