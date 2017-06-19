//
//  ServicesManager.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation
import CoreLocation

/* 
 Service Manager manages the weather services, location service, storing data to Firebase, caching data in UserDefaults
 
 */

// MARK:- ServicesManagerSubscriberDelegate
protocol ServicesManagerSubscriberDelegate {
    var subscribedServices: [(NotificationIdentifiers, Selector)] { get set }
    func Observe(services: [(NotificationIdentifiers, Selector)])
    func unObserve(services: [(NotificationIdentifiers, Selector)])
}

// MARK:- ServicesManagerWeatherDelegate
protocol ServicesManagerWeatherDelegate {
    func weatherDidUpdate(notification: Notification)
}

// MARK:- ServicesManagerForecastDelegate
protocol ServicesManagerForecastDelegate {
    func forecastDidUpdate(notification: Notification)
    func forecastDidFailToUpdate(notification: Notification)
    
}

// MARK:- 
class ServicesManager: NSObject, LocationServiceDelegate, WeatherServiceDelegate {

    //MARK:- Variables
    var locationService: LocationService!
    var weatherService: WeatherService!
    
    private var weatherData: WeatherModel?
    private var forecastData: [WeatherModel]?
    private var currentLocation: CLLocation?
    
    static var shared: ServicesManager = {
        let shared = ServicesManager()
        return shared
    }()
    
    //MARK:- init
     override init() { //This prevents others from using the default '()' initializer for this class.
        super.init()
        self.locationService = LocationService(delegate: self)
        self.weatherService = WeatherService(appid: "", delegate: self)
    }
    
    
    //MARK:- Services
    func startMainService(){
        self.locationService.getGPSLocation()
    }
    
    //MARK:- LocationServiceDelegate
    
    func locationDidUpdate(location: CLLocation){
        self.weatherService.getWeatherServicesForLocation(location: location)
    }
    
    //MARK:- WeatherServiceDelegate

    func weatherDidUpdate(weather: WeatherModel) {
        
        if isWeatherDataChanged(weather: weather){
            weather.addOrUpdateUserData()
        }
        
        self.weatherData = weather
        self.weatherData?.cacheWeather()

        NotificationCenter.default.post(name: Notification.Name(NotificationIdentifiers.weatherDidUpdate.rawValue), object: weather)
    }

    func forecastDidUpdate(forecastList: [WeatherModel]) {
        self.forecastData = forecastList

        ForecastListModel.cacheForecast(forecastList: forecastList)
        NotificationCenter.default.post(name: Notification.Name(NotificationIdentifiers.forecastDidUpdate.rawValue), object: forecastList)
    }
    
    func forecastDidFailToUpdate() {
        NotificationCenter.default.post(name: Notification.Name(NotificationIdentifiers.forecastDidFailToUpdate.rawValue), object: nil)
    }
    
    //MARK:- Services Request
   
    /*  When the shared manager recieves a data request it pass the cached/saved weather instance if found, else it fetches weather for location if found, else it fetches the location to then fetch the weather for this location and post a notification via Notification Center
     */
    func requstWeatherData(completion: (_ weather: WeatherModel) -> ()){
        if let weather = self.getCurrentWeather() { //Weather data isCached/saved
            completion(weather)
        }
        
        else {
            if let location = currentLocation { //Weather data notCached, but Location isCached
                let lat: Float = Float(location.coordinate.latitude)
                let lon: Float = Float(location.coordinate.longitude)
                self.weatherService.getDetailedWeatherForLocation(lat: lat, lon: lon)
            }
            else {//Weather data notCached and Location notCached
                self.locationService.getGPSLocation()
            }
        }
    }
    
    func requstForecastData(completion: (_ forecastList: [WeatherModel]) -> ()){
        if let forecastList = self.getCurrentForecast(){ //Forecast data isCached/saved
            completion(forecastList)
        }
        else {
            if let location = currentLocation { //Forecast data notCached, but Location isCached
                let lat: Float = Float(location.coordinate.latitude)
                let lon: Float = Float(location.coordinate.longitude)
                self.weatherService.getForecastForLocation(lat: lat, lon: lon, daysCount: 7)
            }
            else { //Forecast data notCached and Location notCached
                self.locationService.getGPSLocation()
            }
        }

    }
    
    //MARK:- Cache
    
    func getCurrentWeather() -> WeatherModel? {
        if let weather = self.weatherData {
            return weather
        }
        else if let weather = WeatherModel.getCachedWeather() {
            return weather
        }
        else {
            return nil
        }
    }
    
    func getCurrentForecast() -> [WeatherModel]? {
        if let forecast = self.forecastData {
            return forecast
        }
        else if let forecast = ForecastListModel.getCachedForecast() {
            return forecast
        }
        else {
            return nil
        }
    }

    //MARK:- Helper Method
    func isWeatherDataChanged(weather: WeatherModel) -> Bool{
       
        if self.weatherData?.longitutde != weather.longitutde || self.weatherData?.latitude != weather.latitude || self.weatherData?.tempratureC != weather.tempratureC {
            return true
        }
        else {
            return false
        }
    }
}
