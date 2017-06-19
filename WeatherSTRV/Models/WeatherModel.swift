//
//  WeatherModel.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseDatabase

class WeatherModel: BaseModel {
    
    //MARK:- Variables
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
    var latitude: Float?
    var longitutde: Float?
    var iconImage: UIImage!{
        get {
            return getWeatherConditionIcon()
        }
    }
    var rain: Float?{ //Incase didn't recieve rain object
        didSet{
            if rain == nil {
                rain = 0.0
            }
        }
    }
    var tempratureC: Int? { //From kelvin to Celcuis
        get {
            return calculateCelciusTemperature()
        }
    }
    var weekDay: String?{
        get {
            return getDayOfWeek()
        }
        set{}
    }

    //MARK:- Constants

    /* icon variable, a string, holds the name of weather status. This names is supplied by OpenWeatherMap.
     For a list of possible values see Icon List: http://openweathermap.org/weather-conditions
     Not all cases are covered. Only given Assets
     */
    final var WeatherConditionImageMapper: [String: String] = [
        
        //clear sky
        "01n": "Sun",
        "01d": "Sun",
        
        //thunder, drizzle, rain, snow
        "09d": "Thunder",
        "09n": "Thunder",
        "10d": "Thunder",
        "10n": "Thunder",
        "11d": "Thunder",
        "11n": "Thunder",
        "13d": "Thunder",
        "13n": "Thunder",
        
        //cloud
        "02n": "Cloudy_Sky",
        "02d": "Cloudy_Sky",
        "03n": "Cloudy_Sky",
        "03d": "Cloudy_Sky",
        "04n": "Cloudy_Sky",
        "04d": "Cloudy_Sky",
    ]

    //MARK:- Object Map
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
        latitude        = map["coord.lat"].currentValue as? Float
        longitutde       = map["coord.lon"].currentValue as? Float
        city            <- map["name"]
    }
   
    
    //MARK:- Data Caching
    //MARK: Store
    func cacheWeather() {
        BaseModel.store(self, withKey: "weather")
    }
    
    //MARK: Retreive
    static func getCachedWeather() -> WeatherModel? {
        return BaseModel.getStoredObject(forKey: "weather") as? WeatherModel
    }
    
    //MARK: Encode
    override func encodeData(with aCoder: NSCoder) {
        
        super.encodeData(with: aCoder)
        aCoder.encode(self.mainDescription, forKey:"weather_description")
        aCoder.encode(self.icon           , forKey:"weather_icon")
        aCoder.encode(self.tempratureF    , forKey:"weather_tempratureF")
        aCoder.encode(self.pressure       , forKey:"weather_pressure")
        aCoder.encode(self.rain           , forKey:"weather_rain")
        aCoder.encode(self.speed          , forKey:"weather_speed")
        aCoder.encode(self.direction      , forKey:"weather_direction")
        aCoder.encode(self.cloud          , forKey:"weather_cloud")
        aCoder.encode(self.country        , forKey:"weather_country")
        aCoder.encode(self.latitude       , forKey:"weather_latitude")
        aCoder.encode(self.longitutde     , forKey:"weather_longitutde")
        aCoder.encode(self.city           , forKey:"weather_city")
        aCoder.encode(self.date           , forKey:"weather_date")
        aCoder.encode(self.weekDay        , forKey:"weather_weekDay")

        
    }
    
    //MARK: Decode
    override func decodeData(coder aDecoder: NSCoder) {
        super.decodeData(coder: aDecoder)
        
        if let mainDescription  =  aDecoder.decodeObject(forKey:"weather_description") as? String? {
            self.mainDescription = mainDescription
        }
        
        if let icon  =  aDecoder.decodeObject(forKey:"weather_icon") as? String? {
            self.icon = icon
        }
        
        if let tempratureF  =  aDecoder.decodeObject(forKey:"weather_tempratureF") as? Double? {
            self.tempratureF = tempratureF
        }
        
        if let pressure =  aDecoder.decodeObject(forKey:"weather_pressure") as? Int? {
            self.pressure = pressure
        }
        
        if let rain =  aDecoder.decodeObject(forKey:"weather_rain") as? Float? {
            self.rain = rain
        }
        
        if let speed =  aDecoder.decodeObject(forKey:"weather_speed") as? Float? {
            self.speed = speed
        }
        
        if let direction =  aDecoder.decodeObject(forKey:"weather_direction") as? Double {
            self.direction = direction
        }
        
        if let cloud =  aDecoder.decodeObject(forKey:"weather_cloud") as? Float {
            self.cloud = cloud
        }
        
        if let country =  aDecoder.decodeObject(forKey:"weather_country") as? String? {
            self.country = country
        }
        
        if let latitude  =  aDecoder.decodeObject(forKey:"weather_latitude") as? Float? {
            self.latitude = latitude
        }
        
        if let longitutde = aDecoder.decodeObject(forKey:"weather_longitutde") as? Float? {
            self.longitutde = longitutde
        }
        
        if let city = aDecoder.decodeObject(forKey:"weather_city") as? String? {
            self.city = city
        }
        
        if let date = aDecoder.decodeObject(forKey:"weather_date") as? Date? {
            self.date = date
        }
        
        if let weekDay = aDecoder.decodeObject(forKey:"weather_weekDay") as? String {
            self.weekDay = weekDay
        }
    }

    
    //MARK:- Data Storage
    func addOrUpdateUserData(){
        let ref = Database.database().reference()
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let usersReference = ref.child("device").child(deviceID)
        var values: [String : Any] = [:]

        //Geolocation and Temperature are related. Both should be updated in case of data change
        if let lat = self.latitude {
            if let lon = self.longitutde{
                if let temp = self.tempratureC {
                    values["Geolocation"] = ["lat":lat, "long":lon]
                    values["temperature"] = temp
                }
                
                //city is not always provided by OpenWeather APIs
                if let city = self.city, city != ""{
                    if let country = self.country{
                        values["location"] = ["city":city, "country":country]
                    }
                }
                else {
                    values["location"] = ["city":"Unkowned", "country":"Unkowned"]
                }
            }
        }
        
        //check if nothing to be written
        if values.count < 1 {
            return
        }
        
        //write data
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to write in DB: \(err)")
                return
            }
        })
    }
    
    //MARK:- View Helper Methods
    func calculateCelciusTemperature() -> Int? {
        if let temp = tempratureF {
            return Int(temp - 273.15)
        }
        else {
            return nil
        }
    }
    
    func getWindDirectionInGeographicalDirection() -> String {
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
    func setDateForDay(number: Int){
        var dayComponent = DateComponents()
        dayComponent.day = number
        let calender = NSCalendar.current
        let correspondingDate = calender.date(byAdding: dayComponent, to: Date())
        self.date = correspondingDate
    }
    
    func getDayOfWeek() -> String {
        if let date = self.date {
            return date.dayOfWeek() ?? "N.A"
        }
        else{
            return "N.A"
        }
    }
    
    func getWeatherConditionIcon() -> UIImage {
        
        //Default image
        let defaultImage = #imageLiteral(resourceName: "Sun_Big")
        
        //case no icon returned
        guard let icon = icon else {
            return defaultImage
        }
        
        //case couldn't map image
        guard let iconName = WeatherConditionImageMapper[icon] else {
            return defaultImage
        }
        
        return UIImage(named: iconName) ?? defaultImage
    }
}
