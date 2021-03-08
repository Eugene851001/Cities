//
//  LangPickerViewController.swift
//  Cities
//
//  Created by Admin on 07.03.2021.
//

import UIKit

protocol LangPickerDelegate {
    func langPickerViewControllerDidPickLang(_ lang: String)
}

class LangPickerViewController: UIViewController {

    @IBOutlet weak var picker: UIPickerView!
    
    var delegate: LangPickerDelegate?
    
    private var languages = ["en", "ru"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let row = languages.firstIndex(of: Settings.lang)!
        picker.selectRow(row, inComponent: 0, animated: true)
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

extension LangPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let lang = languages[row]
        if delegate != nil {
            delegate?.langPickerViewControllerDidPickLang(lang)
        }
    }
    
}
