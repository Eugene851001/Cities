//
//  AppDelegate.swift
//  Cities
//
//  Created by Admin on 18.02.2021.
//

import UIKit
import Firebase
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyB9gsvFI0Im1yyEpsuFH86IOfx92RbaRns")
        
        print(UserDefaults.standard.string(forKey: "language")!)
        if let lang = UserDefaults.standard.string(forKey: "language") {
            Settings.lang = lang
        }
        
        print(UserDefaults.standard.float(forKey: "textSize"))
        let textSize = UserDefaults.standard.float(forKey: "textSize")
        if (textSize != 0) {
            Settings.textSize = CGFloat(textSize)
        }
        
        print(UserDefaults.standard.float(forKey: "fontSize"))
        print(UserDefaults.standard.string(forKey: "fontName")!)
        let fontSize = UserDefaults.standard.float(forKey: "fontSize");
        if let fontName = UserDefaults.standard.string(forKey: "fontName") {
            Settings.font = UIFontDescriptor(name: fontName, size: CGFloat(fontSize))
        }
        
        if let color = UserDefaults.standard.colorForKey(key: "color") {
            Settings.color = color
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

