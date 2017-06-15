//
//  APIService.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/14/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import ObjectMapper



class APIService: NSObject {
    
    // MARK:- Server Routes
    static let WindServiceAppId        :String         = "b9a606bcf58b96058b40c4f645d0a568"
    static let baseURL          :String         = "http://api.openweathermap.org/data/2.5/"
    static let defaultImageURL  :String         = ""
    
    fileprivate static let alamoFireManager  = Alamofire.SessionManager.default
    
    
    // Put together a URL With lat and lon
    let path = "weather?lat=51.51&lon=-0.13&cnt=7&appid=b9a606bcf58b96058b40c4f645d0a568"
    

    static func getWeatherDataForLocation(lat: Float, lon: Float, completion: @escaping (_ weather: WeatherModel?, _ success: Bool) -> ()){
        
        
        let url = baseURL + "weather?" + "lat=\(lat)&lon=\(lon)" + "&appid=\(WindServiceAppId)"
        APIService.sendRequest(.get, url: url) { (result, message, success) in
            
            if success {
                if let weather = Mapper<WeatherModel>().map(JSONString: result!)
                {
                    print(weather)
                    completion(weather, true)
                    return
                }
                //failed to fetch weather
                completion(nil, false)
            }
        }
    }
    
    private static func sendRequest(_ method:HTTPMethod, url:String, completion: @escaping (_ result: String?, _ message:String?, _ success:Bool)->()) {
        
        APIService.alamoFireManager.session.configuration.timeoutIntervalForRequest = 60
        
        
        Alamofire.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate(contentType: ["application/json"]).responseString { (response) in
            
            let statusCode:Int? = response.response?.statusCode
            
            if let error = response.result.error {
                completion(nil, error.localizedDescription, false)
                
            }
            else {
                
                if 200 ... 299 ~= statusCode!{
                    completion(response.result.value, "Success", true)
                }
                else {
                    self.connectionError(response.result.value, statusCode: statusCode)
                    
                }
            }
        }
    }
    
    static func connectionError(_ message:String?, statusCode:Int?) {
        //missing
    }
}


