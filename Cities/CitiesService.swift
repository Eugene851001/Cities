//
//  CitiesService.swift
//  Cities
//
//  Created by Admin on 27.02.2021.
//

import Foundation

class CitiesService {
    static let shared = CitiesService()
    
    var cities: [City]?
    var citiesId: [String]?
}
