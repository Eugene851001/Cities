//
//  ErrorAlertFactory.swift
//  Cities
//
//  Created by Admin on 09.03.2021.
//

import Foundation
import UIKit

class ErrorAlertFactory {
    
    static func getAlert(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        return alert
    }
}
