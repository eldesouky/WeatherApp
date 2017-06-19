//
//  BaseModel.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/15/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel: NSObject, Mappable, NSCoding {
   
    required init?(map: Map) {}
    
    func mapping(map: Map) {
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        decodeData(coder: aDecoder)
    }
    
    func encode(with aCoder: NSCoder) {
        encodeData(with: aCoder)
    }
    
    // Storing
    func decodeData(coder aDecoder: NSCoder) {}
    
    func encodeData(with aCoder: NSCoder) {}
    
    static func store(_ object:Any, withKey key:String) {
        let userDefaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: object)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
    }
    
    static func getStoredObject(forKey key:String) -> Any? {
        let userDefaults = UserDefaults.standard
        if let session = userDefaults.data(forKey: key), let currentSession = NSKeyedUnarchiver.unarchiveObject(with: session) {
            return currentSession
        }
        return nil
    }
}
