//
//  City.swift
//  Cities
//
//  Created by Admin on 21.02.2021.
//

import Foundation

class City: Codable {
    
    var name: String
    var country: String?
    var video: String?
    var capital: Bool
    var population: Int?
    var year: Int?
    var mail: String?
    
    var latitude: Double?
    var longitude: Double?
    
    var ID: String?
    
    var images = [String]()
    
    init(name: String, for capital: Bool) {
        self.name = name
        self.capital = capital
    }
}
