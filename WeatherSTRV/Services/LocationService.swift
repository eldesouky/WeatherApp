//
//  LocationService.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate: class {
    func locationDidUpdate(location: CLLocation)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var locationUpdate:((CLLocation)->())?
    weak var delegate: LocationServiceDelegate?
    
    init(delegate: LocationServiceDelegate) {
        
        super.init()
        self.delegate = delegate
    }
    
    // MARK: Location
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
      
        if let location = locations.last {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            //locationManager.stopMonitoringSignificantLocationChanges()
            self.delegate?.locationDidUpdate(location: location)
        }
    }
}
