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


class WeatherService: NSObject {
    
    // Set your appid
    let appid: String
    weak var delegate: WeatherServiceDelegate?
    
    init(appid: String, delegate: WeatherServiceDelegate) {
        self.appid = appid
        self.delegate = delegate
    }
    

    
    func getWeatherServicesForLocation(location: CLLocation?){
        guard let location = location else {
            return
        }
        
        let lat: Float = Float(location.coordinate.latitude)
        let lon: Float = Float(location.coordinate.longitude)

        getDetailedWeatherForLocation(lat: lat, lon: lon)
        getForecastForLocation(lat: lat, lon: lon, daysCount: 7)
        
    }
    
    
    func getDetailedWeatherForLocation(lat: Float, lon: Float) {
        
        APIService.getWeatherDataForLocation(lat: lat, lon: lon) { (weather, success) in
            if success {
                if let weather = weather {
                    weather.setDateForDay(number: 0) //day number 0 as it is today's weather
                    self.delegate?.weatherDidUpdate(weather: weather)
                    return
                }
            }
        }
    }
    
    func getForecastForLocation(lat: Float, lon: Float, daysCount: Int) {
        
        APIService.getForecastDataForLocation(lat: lat, lon: lon, daysCount: daysCount) { (forecastList, success) in
        
            print(success)
            if success {
                if let forecastList = forecastList {
                    self.setupForecastDates(forecastList: forecastList)
                    self.delegate?.forecastDidUpdate(forecastList: forecastList)
                    return
                }
            }
        }
    }
    
    
    func setupForecastDates(forecastList: [WeatherModel]){

        for index in 0...forecastList.count - 1 {
            let forecast = forecastList[index]
            forecast.setDateForDay(number: index)
        }
    }
}
