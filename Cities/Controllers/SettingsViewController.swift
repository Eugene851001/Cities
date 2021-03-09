//
//  SettingsViewController.swift
//  Cities
//
//  Created by Admin on 28.02.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var fontButton: UIButton!
    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    private var selectedColor = Settings.color
    private var colorPicker = UIColorPickerViewController()
    
    private var selectedFont = Settings.font
    private var fontPicker = UIFontPickerViewController()
    
    
    private var textSize: CGFloat = Settings.textSize
    
    @IBAction func onSizeButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "showSizePicker", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        useLocale()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "settings".localized(Settings.lang)
        self.navigationController?.navigationBar.barTintColor = Settings.color
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func useLocale() {
        let lang = Settings.lang
        fontButton.setTitle("font".localized(lang), for: .normal)
        sizeButton.setTitle("size".localized(lang), for: .normal)
        colorButton.setTitle("color".localized(lang), for: .normal)
        languageButton.setTitle("language".localized(lang), for: .normal)
        logoutButton.setTitle("logout".localized(lang), for: .normal)
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
        case "showLanguagePicker":
            let langPicker = segue.destination as! LangPickerViewController
            langPicker.delegate = self
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
        Settings.color = selectedColor
        view.backgroundColor = selectedColor
        print("Color selected")
        UserDefaults.standard.setColor(color: selectedColor, forKey: "color")
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {

    }
}

extension SettingsViewController: UIFontPickerViewControllerDelegate {
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        selectedFont = viewController.selectedFontDescriptor!
        Settings.font = selectedFont
        fontButton.titleLabel?.font = UIFont(descriptor: Settings.font, size: textSize)
        print("Font picked \(selectedFont.pointSize)")
        UserDefaults.standard.set(Float(selectedFont.pointSize), forKey: "fontSize");
        UserDefaults.standard.set(selectedFont.postscriptName, forKey: "fontName");
        
    }
}

extension SettingsViewController: SizePickerDelegate {
    func sizePickerViewControllerDidPickSize(_ textSize: CGFloat) {
        self.textSize = textSize
        Settings.textSize = textSize
        print("Size picked");
        fontButton.titleLabel?.font = UIFont(descriptor: Settings.font, size: Settings.textSize)
        UserDefaults.standard.setValue(Float(textSize), forKey: "textSize")
    }
}

extension SettingsViewController: LangPickerDelegate {
    
    func langPickerViewControllerDidPickLang(_ lang: String) {
        print("Language picked: \(lang)")
        Settings.lang = lang
        print("language".localized(lang))
        useLocale()
        UserDefaults.standard.setValue(lang, forKey: "language")
    }
}

