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
    @IBOutlet weak var populationMinField: UITextField!
    @IBOutlet weak var populationMaxField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var yearFromLabel: UILabel!
    @IBOutlet weak var yearToLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var populationMinLabel: UILabel!
    @IBOutlet weak var populationMaxLabel: UILabel!
    
   
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func onButtonResetClick(_ sender: Any) {
        FilterSettings.capital = nil
        FilterSettings.country = nil
        FilterSettings.yearTo = nil
        FilterSettings.yearFrom = nil
        FilterSettings.name = nil
        FilterSettings.populationTo = nil
        FilterSettings.populationFrom = nil
        
        capitalSwitch.isOn = false
        countryField.text = nil
        yearFromField.text = nil
        yearToField.text = nil
        nameField.text = nil
        populationMaxField.text = nil
        populationMinField.text = nil
    }
    
    @IBAction func onButtonSetClick(_ sender: Any) {
        if FilterValidator.isValidCountry(countryField.text) {
            FilterSettings.country = countryField.text
        } else {
            FilterSettings.country = nil
        }
        
        if yearFromField.text != nil && yearFromField.text!.count > 0 {
            print(yearFromField.text!)
            if !isValidYear(yearFromField.text) {
                return
            }
            
            FilterSettings.yearFrom = Int(yearFromField.text!)
        } else {
            FilterSettings.yearFrom = nil
        }
        
        if yearToField.text != nil && yearToField.text!.count > 0 {
            print(yearToField.text!)
            if !isValidYear(yearToField.text) {
                return
            }
            
            FilterSettings.yearTo = Int(yearToField.text!)
        } else {
            FilterSettings.yearTo = nil
        }
        
        if nameField.text != nil && nameField.text!.count > 0 {
            FilterSettings.name = nameField.text
        } else {
            FilterSettings.name = nil
        }
        
        if populationMinField.text != nil && populationMinField.text!.count > 0 {
            if !isValidPopulation(populationMinField.text) {
                return
            }
            
            FilterSettings.populationFrom = Int(populationMinField.text!)
        } else {
            FilterSettings.populationFrom = nil
        }
        
        if populationMaxField.text != nil && populationMaxField.text!.count > 0 {
            if !isValidPopulation(populationMaxField.text) {
                return
            }
            
            FilterSettings.populationTo = Int(populationMaxField.text!)
        } else {
            FilterSettings.populationTo = nil
        }
        
        FilterSettings.capital = capitalSwitch.isOn
    }

    
    private func isValidYear(_ year: String?) -> Bool {
        let validatorResult = CityValidator.isValidYear(year)
        if validatorResult != nil {
            let alert = ErrorAlertFactory.getAlert(validatorResult!)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    private func isValidPopulation(_ population: String?) -> Bool {
        let validatorResult = CityValidator.isValidPopulation(population)
        if validatorResult != nil {
            let alert = ErrorAlertFactory.getAlert(validatorResult!)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let lang = Settings.lang
        countryLabel.text = "country".localized(lang)
        yearFromLabel.text = "yearFrom".localized(lang)
        yearToLabel.text = "yearTo".localized(lang)
        capitalLabel.text = "capital".localized(lang)
        nameLabel.text = "name".localized(lang)
        populationMinLabel.text = "populationMin".localized(lang)
        populationMaxLabel.text = "populationMax".localized(lang)
        setButton.setTitle("set".localized(lang), for: .normal)
        resetButton.setTitle("reset".localized(lang), for: .normal)
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
        
        if let name = FilterSettings.name {
            nameField.text = name
        }
        
        if let populationFrom = FilterSettings.populationFrom {
            populationMinField.text = String(describing: populationFrom)
        }
        
        if let populationTo = FilterSettings.populationTo {
            populationMaxField.text = String(describing: populationTo)
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
