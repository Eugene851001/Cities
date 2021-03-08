//
//  CitiesListViewController.swift
//  Cities
//
//  Created by Admin on 20.02.2021.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var citiesTable: UITableView!
    
    @IBOutlet weak var tabBar: UITabBarItem!
    
    var cities = [City]()
    var citiesId = [String]()
    var currentIndex = 0
    
    private var currentUserMail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(onFilterClicked))
       // self.navigationController?.navigationBar.tintColor = Settings.color

    }
    
    @objc func onFilterClicked() {
        performSegue(withIdentifier: "showFilterSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! CityTableViewCell
        
        let city = cities[indexPath.row];
        cell.nameLabel.text = city.name
        cell.nameLabel.font = UIFont(descriptor: Settings.font, size: Settings.textSize)
        cell.countryLabel.text = city.country
        cell.countryLabel.backgroundColor = Settings.color
        
        if city.mail == currentUserMail {
            print("\(city.name): \(city.mail)")
            cell.backgroundColor = UIColor.green
        }
        
        if (city.images.count > 0) {
            let imageRef = Storage.storage().reference().child(city.images[0])
            imageRef.getData(maxSize: 5 * 1024 * 1024, completion: {(data, err) in
                if let myError = err {
                    print(myError)
                    return
                }
                let img = UIImage(data: data!)
                cell.avatarImageView.image = img
            })
        }
        
        let lang = Settings.lang
        cell.capitalLabel.text = city.capital ? "capital".localized(lang) : ""
        cell.populationLabel.text = "\("population".localized(lang)): \(city.population!)"
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // tabBar.badgeColor = Style.color
        
        if let mail = UserDefaults.standard.string(forKey: "mail") {
            currentUserMail = mail
        }
        
        self.navigationController?.navigationBar.backgroundColor = Settings.color
        let db = Firestore.firestore()
        db.collection("cities").getDocuments(completion: {(querySnapshot, err) in
            if (err != nil) {
                print(err!)
                
            } else {
                for document in querySnapshot!.documents {
                    let name = String(describing: document.data()["name"])
                    self.citiesId.append(document.documentID)
                    print(name)
                }
                let cities = querySnapshot!.documents
                self.cities = cities.compactMap({try? $0.data(as: City.self)})
                
                if (FilterSettings.country != nil) {
                    print("Filter by country \(FilterSettings.country!)")
                    self.cities = self.cities.compactMap({$0.country == FilterSettings.country ? $0 : nil})
                }
                
                if (FilterSettings.capital != nil && FilterSettings.capital!) {
                    print("Filter by capital \(FilterSettings.capital!)")
                    self.cities = self.cities.compactMap({$0.capital ? $0 : nil})
                }
                
                if (FilterSettings.yearFrom != nil) {
                    print("Filter by year from \(FilterSettings.yearFrom!)")
                    self.cities = self.cities.compactMap({$0.year! >= FilterSettings.yearFrom! ? $0 : nil})
                }
                
                if (FilterSettings.yearTo != nil) {
                    print("Filter by year to \(FilterSettings.yearTo!)")
                    self.cities = self.cities.compactMap({$0.year! <= FilterSettings.yearTo! ? $0 : nil})
                }
                
                self.citiesTable.reloadData()
                CitiesService.shared.cities = self.cities
                CitiesService.shared.citiesId = self.citiesId
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showCitySegue":
            let destination = segue.destination as! CityViewController
            destination.currentCity = cities[currentIndex]
            destination.cityId = citiesId[currentIndex]
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        
        performSegue(withIdentifier: "showCitySegue", sender: self)
    }

}
