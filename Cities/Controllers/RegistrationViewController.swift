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
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var isCapitalSwitch: UISwitch!
    @IBOutlet weak var populationField: UITextField!
    
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        
        let lang = Settings.lang
        mailLabel.text = "mail".localized(lang)
        passwordLabel.text = "password".localized(lang)
        nameLabel.text = "name".localized(lang)
        capitalLabel.text = "capital".localized(lang)
        populationLabel.text = "population".localized(lang)
        yearLabel.text = "year".localized(lang)
        capitalLabel.text = "capital".localized(lang)
        countryLabel.text  = "country".localized(lang)
        registrationButton.setTitle("registrate".localized(lang), for: .normal)
    }
    
    
    @IBAction func onRegistrate(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        let name = nameField.text!
        let population = Int(populationField.text!)
        let year = Int(yearField.text!)
        let capital = isCapitalSwitch.isOn
        
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
                                        let city = City(name: name, for: capital)
                                        city.country = country
                                        city.latitude = latitude
                                        city.longitude = longitude
                                        city.year = year
                                        city.population = population
                                        city.capital = capital
                                        city.mail = email
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
