//
//  WeatherModel.swift
//  MAWeather
//
//  Created by Vishwavijet on 09/12/18.
//  Copyright © 2018 Tarento. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
    var name: String?
    var temp: Double?
    var main: String?
    var desc: String?
    
    init(_ dictionary: Dictionary<String, Any>) {
        super.init()
        self.name = dictionary["name"] as? String
        let main = dictionary["main"]! as! Dictionary<String, Any>
        self.temp = (main["temp"] as? Double)! - 273.15
//        self.main = dictionary["weather"]![0]["main"] as? String
//        self.desc = dictionary["weather"]![0]["description"] as? String
    }

}
