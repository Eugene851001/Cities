//
//  CityValidator.swift
//  Cities
//
//  Created by Admin on 09.03.2021.
//

import Foundation

class CityValidator {
    
    static func isValidLatitude(_ latitude: String?) -> String? {
        
        if (latitude == nil || latitude?.count == 0) {
            return "Please, enter the latitude value"
        }
        
        guard let value = Float(latitude!) else {
            return "The latitude should be float number"
        }
        
        if value < -90 || value > 90 {
            return "The latitude value should be from -90 to 90"
        }
        
        return nil
    }
    
    static func isValidLongitide(_ longitude: String?) -> String? {
        
        if (longitude == nil || longitude?.count == 0) {
            return "Please, enter the latitude value"
        }
        
        guard let value = Float(longitude!) else {
            return "The latitude should be float number"
        }
        
        let minValue: Float = 0.0
        let maxValue: Float = 180.0
        if value < minValue || value > maxValue {
            return "The latitude value should be from \(minValue) to \(maxValue)"
        }
        
        return nil
    }
    
    static func isValidPopulation(_ populaiton: String?) -> String? {
        
        if populaiton == nil || populaiton?.count == 0 {
            return  "Enter the value of population"
        }
        
        guard let value = Int(populaiton!) else {
            return "The population shoukd be integer"
        }
        
        let minValue = 0
        if value < minValue {
            return "The population should be greater than \(minValue)"
        }
        
        return nil
    }
    
    static func isValidYear(_ year: String?) -> String? {
       
        if year == nil || year?.count == 0 {
            return "Please, enter the value for year"
        }
        
        guard let value = Int(year!) else {
            return "The year should be integer"
        }
        
        let minValue = 0
        let maxValue = 2021
        
        if value < minValue || value > maxValue {
            return "The value should be from \(minValue) to \(maxValue)"
        }
            
        return nil
    }
}
