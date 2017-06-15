//
//  WeatherModel.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 
 icon, a string, holds the name of weather status. This names is supplied by OpenWeatherMap.
 For a list of possible values see Icon List: http://openweathermap.org/weather-conditions
 
 temp => temperature in Kelvin.
 tempF and tempC are computed properties that return temp in Farenheit, and Celsius.
 
 Note: tempMin, and tempMax are not as intersting as they sound, see the notes on these in
 the OpenWeatherMap API.
 
 */

class WeatherModel: BaseModel {
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



    /* 
     
     {
     "weather": [
     {
     "main": "Clear",
     "description": "clear sky",
     "icon": "01d"
     }
     ],
     "main": {
     "temp": 292.65,
     "pressure": 1015, hPa
     "humidity": 60,
    },
     "wind": {
     "speed": 6.7,
     "deg": 90
     },
     "clouds": {
     "all": 0
     },
     "dt": 1497469800,
     "sys": {
     "country": "GB",
    },
     "name": "London",
     "cod": 200
     }

     */

    
