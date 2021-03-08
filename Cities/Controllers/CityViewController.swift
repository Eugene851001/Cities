//
//  CityViewController.swift
//  Cities
//
//  Created by Admin on 22.02.2021.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import AVKit
import AVFoundation

class CityViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentCity: City!
    var cityId: String!
    var images = [UIImage]()
    
    var videoPlayer: AVPlayer?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var populationField: UITextField!
    @IBOutlet weak var capitalSwitch: UISwitch!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBAction func onGalleryButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "showGallerySegue", sender: self)
    }
    
    @IBAction func onPlayVideoClick(_ sender: Any) {
        if let player = videoPlayer {
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showGallerySegue") {
            let gallery = segue.destination as! GalleryViewController
            gallery.img = photoView.image
            gallery.images = images
        }
    }
    
    @IBAction func onSaveButtonClick(_ sender: Any) {
        currentCity.name = nameField.text!
        currentCity.country = countryField.text!
        
        if let population = Int(populationField.text!) {
            currentCity.population = population;
        }
        
        if let year  = Int(yearField.text!) {
            currentCity.year = year
        }
        
        currentCity.capital = capitalSwitch.isOn
        
        let db = Firestore.firestore()
        do {
            let _ = try db.collection("cities").document(cityId).setData(from: currentCity)
        } catch {
            print(error)
        }
        
        performSegue(withIdentifier: "showCitiesSegue", sender: self)
    }
    
    @IBAction func onAddVideoButtonClick(_ sender: Any) {
        currentCity.video = "videos/Example.mp4"
        
        /*let videoPicker = UIImagePickerController()
        videoPicker.allowsEditing = false
        videoPicker.delegate = self
        videoPicker.mediaTypes = ["public.movie"]
        self.present(videoPicker, animated: true)*/
    }
    
    @IBAction func onAddImageButtonClick(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFields(currentCity)
        setImages(currentCity)
        setVideo(currentCity)
        getImages()
        localizeLabels()
        
        if currentCity.video == nil {
            videoButton.isEnabled = false
        } else {
            videoButton.isEnabled = true
        }
    }
    
    func setVideo(_ city: City) {
        if let videoPath = city.video {
            let videoRef = Storage.storage().reference().child(videoPath)
            videoRef.downloadURL(completion: {(URL, err) in
                if let myError = err {
                    print(myError)
                    return
                }
                
                self.videoPlayer = AVPlayer(url: URL!)
                let layer = AVPlayerLayer(player: self.videoPlayer)
                layer.frame = self.videoView.layer.bounds
                self.videoView.layer.addSublayer(layer)
            })

        }
    }
    
    func getImages() {
        for path in currentCity.images {
            let imageRef = Storage.storage().reference().child(path)
            imageRef.getData(maxSize: 5 * 1024 * 1024, completion: {(data, err) in
                if let myError = err {
                    print(myError)
                    return
                }
                let img = UIImage(data: data!)
                self.images.append(img!)
            })
        }
    }
    
    func setFields(_ city: City) {
        nameField.text = city.name
        countryField.text = city.country
        
        if let population = city.population {
            populationField.text = String(describing: population)
        }
        
        if let year = city.year {
            yearField.text = String(describing: year)
        }
        
        capitalSwitch.isOn = city.capital
    }
    
    func setImages(_ city: City) {
        if (city.images.count < 1) {
            return
        }
        
        let imageRef = Storage.storage().reference().child(city.images[0])
        imageRef.getData(maxSize: 5 * 1024 * 1024) { data, err in
            if let myError = err {
                print(myError)
                return
            }
            
            self.photoView.image = UIImage(data: data!)
        }
    }
    
    func localizeLabels() {
        let lang = Settings.lang
        nameLabel.text = "name".localized(lang)
        countryLabel.text = "country".localized(lang)
        populationLabel.text = "population".localized(lang)
        yearLabel.text = "year".localized(lang)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photoURL = info[.imageURL] as! URL
        print(photoURL)
        let image = info[.originalImage] as! UIImage
        photoView.image = image
        let firebaseImagePath = "images/\(String(describing: cityId))/\(currentCity.images.count)"
        let imageRef = Storage.storage().reference().child(firebaseImagePath)
        imageRef.putFile(from: photoURL, metadata: nil){ (data, err) in
            if let myError = err {
                print(myError)
            }
        }
        
        currentCity.images.append(firebaseImagePath)
    }
}
