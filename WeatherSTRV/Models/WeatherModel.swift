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
    var tempratureF: Double?
    var pressure: Int?
    var speed: Float?
    var direction: Double?
    var cloud:Float?
    var country: String?
    var city: String?
    var date: Date?
    var weekDay: String?
    var rain: Float?{ //Incase didn't recieve rain object
        didSet{
            if rain == nil {
                rain = 0.0
            }
        }
    }
    var tempratureC: Int? { //From kelvin to Celcuis
        get {
            if let temp = tempratureF {
                return Int(temp - 273.15)
            }
            else {
                return nil
            }
        }
    }
    
    override func mapping(map: Map) {
        
        mainDescription = map["weather.0.main"].currentValue as? String
        icon            = map["weather.0.icon"].currentValue as? String
        tempratureF     = map["main.temp"].currentValue as? Double
        pressure        = map["main.pressure"].currentValue as? Int
        rain            = map["rain.3h"].currentValue as? Float
        speed           = map["wind.speed"].currentValue as? Float
        direction       = map["wind.deg"].currentValue as? Double
        cloud           = map["clouds.all"].currentValue as? Float
        country         = map["sys.country"].currentValue as? String
        city            <- map["name"]
    }
  
    func windDirectionInGeographicalDirection() -> String {
        
        guard let direction = self.direction else {
            return "----"
        }
        var compassDirection: String?
        
        if ((direction >= 339) || (direction <= 22)) {
            compassDirection = "N";
        }else if ((direction > 23) && (direction <= 68)) {
            compassDirection = "NE";
        }else if ((direction > 69) && (direction <= 113)) {
            compassDirection = "E";
        }else if ((direction > 114) && (direction <= 158)) {
            compassDirection = "SE";
        }else if ((direction > 159) && (direction <= 203)) {
            compassDirection = "S";
        }else if ((direction > 204) && (direction <= 248)) {
            compassDirection = "SW";
        }else if ((direction > 249) && (direction <= 293)) {
            compassDirection = "W";
        }else if ((direction > 294) && (direction <= 338)) {
            compassDirection = "NW";
        }
        return compassDirection ?? "----"
    }
    
    /* setup the forcast "date" variable to its corresponding date*/
    func setupDateForDay(number: Int){
        var dayComponent = DateComponents()
        dayComponent.day = number
        let calender = NSCalendar.current
        let correspondingDate = calender.date(byAdding: dayComponent, to: Date())
        self.date = correspondingDate
        self.weekDay = correspondingDate?.dayOfWeek()
    }
    
    
}
