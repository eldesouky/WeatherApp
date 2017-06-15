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
    
     override init() { //This prevents others from using the default '()' initializer for this class.
        super.init()
        self.locationService = LocationService(delegate: self)
        self.weatherService = WeatherService(appid: "", delegate: self)
    }
    
    func startMainService(){
      
        self.locationService.getGPSLocation()
        
    }
    
    func locationDidUpdate(location: CLLocation){
        self.weatherService.getWeatherForLocation(location: location)
    }
    
    func weatherDidUpdate(weather: WeatherModel) {
        NotificationCenter.default.post(name: Notification.Name("weatherDidUpdate"), object: weather)
    }
    
    func forecastDidUpdate(weather: WeatherModel) {
        
    }

    
}


