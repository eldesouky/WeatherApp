//
//  ForecastModel.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/15/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation

class ForecastModel: BaseModel {
   
    var mainDescription: String?
    var icon: String?
    var temprature: Float?
    var pressure: Int?
    var humidity: Int?
    var speed: Float?
    var country: String?
    var city: String?
    
    override func mapping(map: Map) {
        
        mainDescription = map["weather.0.main"].currentValue as? String
        icon            = map["weather.0.icon"].currentValue as? String
        temprature      = map["main.temp"].currentValue as? Float
        pressure        = map["main.pressure"].currentValue as? Int
        humidity        = map["main.humidity"].currentValue as? Int
        speed           = map["wind.speed"].currentValue as? Float
        country         = map["sys.country"].currentValue as? String
        city            <- map["name"]
    }
}
