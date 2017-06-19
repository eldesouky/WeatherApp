//
//  LocationService.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import CoreLocation

// MARK:- LocationServiceDelegate
protocol LocationServiceDelegate: class {
    func locationDidUpdate(location: CLLocation)
}

// MARK:-
class LocationService: NSObject, CLLocationManagerDelegate {
    
    // MARK:- Variables
    var locationManager: CLLocationManager!
    var locationUpdate:((CLLocation)->())?
    weak var delegate: LocationServiceDelegate?
    
    // MARK:- init
    init(delegate: LocationServiceDelegate) {
        
        super.init()
        self.delegate = delegate
    }
    
    // MARK:- Location Services
    /** Get the GPS location.  */
    func getGPSLocation() {
        setupLocationManager()
        startLocationService()
    }
    
    func setupLocationManager(){
        if((locationManager) != nil)
        {
            locationManager.stopMonitoringSignificantLocationChanges()
            locationManager.delegate = nil
            locationManager = nil
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func startLocationService(){
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    //MARK:- CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedAlways
        {
            locationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        if let location = manager.location {
            print("locations = \(location.coordinate.latitude) \(location.coordinate.longitude)")
            //locationManager.stopMonitoringSignificantLocationChanges()
            self.delegate?.locationDidUpdate(location: location)
        }
    }
}
