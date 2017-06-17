//
//  ServicesManager.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation
import CoreLocation

class ServicesManager: NSObject, LocationServiceDelegate, WeatherServiceDelegate {
    
    static var shared: ServicesManager = {
        let shared = ServicesManager()
        return shared
    }()
    
    var locationService: LocationService!
    var weatherService: WeatherService!
    
    private var weatherData: WeatherModel?
    private var forecastData: [WeatherModel]?
    private var currentLocation: CLLocation?
    
     override init() { //This prevents others from using the default '()' initializer for this class.
        super.init()
        self.locationService = LocationService(delegate: self)
        self.weatherService = WeatherService(appid: "", delegate: self)
    }
    
    func startMainService(){
      
        self.locationService.getGPSLocation()
        
    }
    
    //MARK:- WeatherServiceDelegate
    
    func locationDidUpdate(location: CLLocation){
        self.weatherService.getWeatherServicesForLocation(location: location)
    }
    
    
    //MARK:- WeatherServiceDelegate

    func weatherDidUpdate(weather: WeatherModel) {
        
        if self.weatherData?.longitutde != weather.longitutde || self.weatherData?.latitude != weather.latitude || self.weatherData?.tempratureC != weather.tempratureC {
            weather.addOrUpdateUserData()
        }
        
        self.weatherData = weather
        NotificationCenter.default.post(name: Notification.Name(NotificationIdentifiers.weatherDidUpdate.rawValue), object: weather)
    }
    
    func forecastDidUpdate(forecastList: [WeatherModel]) {
        self.forecastData = forecastList
        NotificationCenter.default.post(name: Notification.Name(NotificationIdentifiers.forecastDidUpdate.rawValue), object: forecastList)
    }
    
    //MARK:- Services Request
   
    /*  When the shared manager recieves a data request it pass the saved weather instance if found, else it fetches weather for location if found, else it fetches the location to then fetch the weather for this location and post a notification via Notification Center
     */
    func requstWeatherData(completion: (_ weather: WeatherModel) -> ()){
        if let weather = self.weatherData {
            completion(weather)
        }
        else {
            if let location = currentLocation {
                let lat: Float = Float(location.coordinate.latitude)
                let lon: Float = Float(location.coordinate.longitude)
                self.weatherService.getDetailedWeatherForLocation(lat: lat, lon: lon)
            }
            else {
                self.locationService.getGPSLocation()
            }
        }
    }
    
    func requstForecastData(completion: (_ forecastList: [WeatherModel]) -> ()){
        if let forecastList = self.forecastData {
            completion(forecastList)
        }
        else {
            if let location = currentLocation {
                let lat: Float = Float(location.coordinate.latitude)
                let lon: Float = Float(location.coordinate.longitude)
                self.weatherService.getForecastForLocation(lat: lat, lon: lon, daysCount: 7)
            }
            else {
                self.locationService.getGPSLocation()
            }
        }

    }
    
}
