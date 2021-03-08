//
//  FilterViewController.swift
//  Cities
//
//  Created by Admin on 04.03.2021.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var yearToField: UITextField!
    @IBOutlet weak var yearFromField: UITextField!
    @IBOutlet weak var capitalSwitch: UISwitch!
    
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var yearFromLabel: UILabel!
    @IBOutlet weak var yearToLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    
    
    @IBOutlet weak var setButton: UIButton!
    
    @IBAction func onButtonSetClick(_ sender: Any) {
        if FilterValidator.isValidCountry(countryField.text) {
            FilterSettings.country = countryField.text
        } else {
            FilterSettings.country = nil
        }
        
        if yearFromField.text != nil, let yearFrom = Int(yearFromField.text!) {
            FilterSettings.yearFrom = yearFrom
        } else {
            FilterSettings.yearFrom = nil
        }
        
        if yearToField.text != nil, let yearTo = Int(yearToField.text!) {
            FilterSettings.yearTo = yearTo
        } else {
            FilterSettings.yearTo = nil
        }
        
        FilterSettings.capital = capitalSwitch.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let lang = Settings.lang
        countryLabel.text = "country".localized(lang)
        yearFromLabel.text = "yearFrom".localized(lang)
        yearToLabel.text = "yearTo".localized(lang)
        capitalLabel.text = "capital".localized(lang)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let country = FilterSettings.country {
            countryField.text = country
        }
        
        if let yearFrom = FilterSettings.yearFrom {
            yearFromField.text = String(describing: yearFrom)
        }
        
        if let yearTo = FilterSettings.yearTo {
            yearToField.text = String(yearTo)
        }
        
        capitalSwitch.isOn = FilterSettings.capital ?? false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
