//
//  FilterValidator.swift
//  Cities
//
//  Created by Admin on 08.03.2021.
//

import Foundation

class FilterValidator {
    
    static func isValidCountry(_ country: String?) -> Bool{
        if country == nil {
            return false
        }
        
        if (country!.count == 0) {
            return false
        }
        
        return true
    }
    
    static func isValidYear(start yearFrom: Int?, end yearTo: Int?) -> Bool {
        if yearFrom == nil || yearTo == nil {
            return false
        }
            
        if (yearFrom! < 0 || yearTo! < 0) {
            return false
        }
            
        if (yearFrom! > yearTo!) {
            return false
        }
        
        return true
    }
}
