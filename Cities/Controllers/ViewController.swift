//
//  ViewController.swift
//  Cities
//
//  Created by Admin on 18.02.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    @IBAction func onSignIn(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(userData, err) in
            if (err != nil) {
                
                let alert = ErrorAlertFactory.getAlert(String(describing: "Please, check email and password"))
                self.present(alert, animated: true, completion: nil)
                print(err!)
            } else {
                
                self.emailField.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                print("Signed in")
                UserDefaults.standard.setValue(email, forKey: "mail")
                self.performSegue(withIdentifier: "showCitiesSegue", sender: self)
            }
        })
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordLabel.text = "password".localized(Settings.lang)
        emailLabel.text = "email".localized(Settings.lang)
        registrationButton.setTitle("registration".localized(Settings.lang), for: .normal)
        signinButton.setTitle("signin".localized(Settings.lang), for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    //    self.navigationController?.setNavigationBarHidden(false, animated: animated)
     //   self.tabBarController?.tabBar.isHidden = false
    }


}

