//
//  SizePickerViewController.swift
//  Cities
//
//  Created by Admin on 28.02.2021.
//

import UIKit

protocol SizePickerDelegate {
    func sizePickerViewControllerDidPickSize(_ textSize: CGFloat)
}

class SizePickerViewController: UIViewController {
    
    var delegate: SizePickerDelegate?

    private var textSize: CGFloat = 17.0
    
    
    private var textSizes = ["15.0", "17.0", "18.0", "19.0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension SizePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return textSizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(textSizes.count)
        return textSizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("Text size\(textSizes[0])")
        return textSizes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textSize = CGFloat(Float(textSizes[row])!)
        Style.textSize = textSize
        if delegate != nil {
            delegate?.sizePickerViewControllerDidPickSize(textSize)
        }
        print("Size picked")
    }
    
}
