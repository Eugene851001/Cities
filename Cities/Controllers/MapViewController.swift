//
//  MapViewController.swift
//  Cities
//
//  Created by Admin on 25.02.2021.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var cities = [City]()
    var citiesId = [String]()
    
    var currentCityIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitude = 53.906321
        let longitude = 21.570538
        let camera =  GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 6.0)
        let mapView = GMSMapView(frame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Title"
        marker.snippet = "Snippet"
        marker.map = mapView
        
        cities = CitiesService.shared.cities!
        citiesId = CitiesService.shared.citiesId!
        
        for city in cities {
            guard let latitude = city.latitude,
                  let longitude = city.longitude else {
                continue;
            }
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.title = city.name
            print(city.name)
            marker.snippet = "Snippet"
            marker.map = mapView
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showCitySegue":
            let cityView = segue.destination as! CityViewController
            cityView.cityId = citiesId[currentCityIndex]
            cityView.currentCity = cities[currentCityIndex]
        default:
            break
        }
    }
    
}


extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("Tapped infoWindow\(marker.position)")
        //TODO: change this later
        var  i = 0
        for city in cities {
            if city.latitude == marker.position.latitude
                && city.longitude == marker.position.longitude {
                currentCityIndex = i
            }
            i += 1
        }
        
        performSegue(withIdentifier: "showCitySegue", sender: self)
    }
}
