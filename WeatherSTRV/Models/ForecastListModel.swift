//
//  ForecastModel.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/15/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation
import ObjectMapper

class ForecastListModel: BaseModel {
    
    // MARK:- Variables
    var records:[WeatherModel]? = []

    // MARK:- Map
    override func mapping(map: Map) {
        records <- map["list"]
    }

    //MARK:- Data Caching
    //MARK: Store
    static func cacheForecast(forecastList: [WeatherModel]) {
        BaseModel.store(forecastList, withKey: "forecast")
    }
    
    //MARK: Retreive
    static func getCachedForecast() -> [WeatherModel]? {
        return ForecastListModel.getStoredObjects(forKey: "forecast")
    }
    
    //MARK:- Array Storage
    static func getStoredObjects(forKey key:String) -> [WeatherModel]? {
        let userDefaults = UserDefaults.standard
        if let session = userDefaults.data(forKey: key), let currentSession = NSKeyedUnarchiver.unarchiveObject(with: session) as? [WeatherModel] {
            return currentSession
        }
        return nil
    }

}
