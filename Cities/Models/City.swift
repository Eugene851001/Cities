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
    
    var latitude: Double?
    var longitude: Double?
    
    var ID: Int?
    
    var images = [String]()
    
    init(name: String) {
        self.name = name
    }
}
