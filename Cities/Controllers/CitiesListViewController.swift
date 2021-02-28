//
//  CitiesListViewController.swift
//  Cities
//
//  Created by Admin on 20.02.2021.
//

import Foundation
import UIKit
import FirebaseFirestore

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var citiesTable: UITableView!
    
    @IBOutlet weak var tabBar: UITabBarItem!
    
    var cities = [City]()
    var citiesId = [String]()
    var currentIndex = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! CityTableViewCell
        
        cell.nameLabel.text = cities[indexPath.row].name
        cell.countryLabel.text = cities[indexPath.row].country
        cell.countryLabel.backgroundColor = Style.color
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.badgeColor = Style.color
        
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
