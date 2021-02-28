//
//  RegistrationViewController.swift
//  Cities
//
//  Created by Admin on 20.02.2021.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class RegistrationViewController: UIViewController {
    

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    override func  viewDidLoad() {
        
    }
    
    
    @IBAction func onRegistrate(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        let name = nameField.text!
        guard let latitude = Double(latitudeField.text!)
              ,let longitude = Double(longitudeField.text!) else {
            print("Check coordinates")
            return;
        }
        Auth.auth().createUser(withEmail: email, password: password, completion:
                                {(user, err) in
                                    if (err != nil) {
                                        self.emailField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                                        print(err!)
                                    } else {
                                        self.emailField.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                                        print("Registrated")
                                        let country = self.countryField.text!
                                        let city = City(name: name)
                                        city.country = country
                                        city.latitude = latitude
                                        city.longitude = longitude
                                        let db = Firestore.firestore()
                                        do {
                                            let _ = try db.collection("cities").addDocument(from: city)
                                        } catch {
                                            print(error)
                                        }
                                        self.performSegue(withIdentifier: "showSignInSegue", sender: self)
                                    }
                                })
        
    }
}
