//
//  BaseModel.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/15/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel: NSObject, Mappable {
    required init?(map: Map) {}
    
    func mapping(map: Map) {
    }
    
}
