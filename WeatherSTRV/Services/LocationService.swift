//
//  LocationService.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var locationUpdate:((CLLocation)->())?
    
    override init() {
        
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
    }
    
    //MARK:- CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways
        {
            locationManager.startMonitoringSignificantLocationChanges()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            locationUpdate?(lastLocation)
        }
    }
    
    
    
}
