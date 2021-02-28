//
//  SettingsViewController.swift
//  Cities
//
//  Created by Admin on 28.02.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var fontButton: UIButton!
    
    private var selectedColor = Style.color
    private var colorPicker = UIColorPickerViewController()
    
    private var selectedFont = Style.font
    private var fontPicker = UIFontPickerViewController()
    
    
    private var textSize: CGFloat = Style.textSize
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func selectColor() {
        
        colorPicker.delegate = self
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = selectedColor!
        present(colorPicker, animated: true)
    }
    
    @IBAction func onColorButtonClick(_ sender: Any) {
        selectColor()
    }
    
    @IBAction func onFontButtonClick(_ sender: Any) {
        selectFont()
    }
    
    private func selectFont() {
        fontPicker.delegate = self
        fontPicker.selectedFontDescriptor = selectedFont
        present(fontPicker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showSizePicker":
            let sizePicker = segue.destination as! SizePickerViewController
            sizePicker.delegate = self
        default:
            break
        }
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


extension SettingsViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        Style.color = selectedColor
        view.backgroundColor = selectedColor
        print("Color selected")
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {

    }
}

extension SettingsViewController: UIFontPickerViewControllerDelegate {
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        selectedFont = viewController.selectedFontDescriptor!
        Style.font = selectedFont
        fontButton.titleLabel?.font = UIFont(descriptor: Style.font, size: textSize)
        print("Font picked")
    }
}

extension SettingsViewController: SizePickerDelegate {
    func sizePickerViewControllerDidPickSize(_ textSize: CGFloat) {
        self.textSize = textSize
        Style.textSize = textSize
        print("Size picked");
        fontButton.titleLabel?.font = UIFont(descriptor: Style.font, size: Style.textSize)
    }
    
    
}

