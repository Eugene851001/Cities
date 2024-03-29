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
   /// var cityId: String!
    var images = [UIImage]()
    
    var videoPlayer: AVPlayer?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var populationField: UITextField!
    @IBOutlet weak var capitalSwitch: UISwitch!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var mailLabel: UILabel!
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
        
        var validatorResult = CityValidator.isValidPopulation(populationField.text)
        if validatorResult != nil {
            let alert = ErrorAlertFactory.getAlert(validatorResult!)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        validatorResult = CityValidator.isValidYear(yearField.text)
        if validatorResult != nil {
            let alert = ErrorAlertFactory.getAlert(validatorResult!)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        validatorResult = CityValidator.isValidLatitude(latitudeField.text)
        if validatorResult != nil {
            let alert = ErrorAlertFactory.getAlert(validatorResult!)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        validatorResult = CityValidator.isValidLongitide(longitudeField.text)
        if validatorResult != nil {
            let alert = ErrorAlertFactory.getAlert(validatorResult!)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        currentCity.name = nameField.text!
        currentCity.country = countryField.text!
        
        if let population = Int(populationField.text!) {
            currentCity.population = population;
        }
        
        if let year  = Int(yearField.text!) {
            currentCity.year = year
        }
        
        if let latitude = Double(latitudeField.text!) {
            currentCity.latitude = latitude
        }
        
        if let longitude = Double(longitudeField.text!) {
            currentCity.longitude = longitude
        }
        
        currentCity.capital = capitalSwitch.isOn
        
        let db = Firestore.firestore()
        do {
            let _ = try db.collection("cities").document(currentCity.ID!).setData(from: currentCity)
        } catch {
            print(error)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddVideoButtonClick(_ sender: Any) {
        
        let videoPicker = UIImagePickerController()
        videoPicker.allowsEditing = false
        videoPicker.delegate = self
        videoPicker.mediaTypes = ["public.movie"]
        self.present(videoPicker, animated: true)
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "city".localized(Settings.lang)
    }
    
    func setVideo(_ city: City) {
        if let videoPath = city.video {
            self.playButton.isHidden = false
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
                self.videoPlayer?.seek(to: .zero)
            })

        } else {
            self.playButton.isHidden = true
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
        
        if let latitude = city.latitude {
            latitudeField.text = String(describing: latitude)
        }
        
        if let longitude = city.longitude {
            longitudeField.text = String(describing: longitude)
        }
        
        if let mail = city.mail {
            mailField.text = mail
            mailField.isUserInteractionEnabled = false
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
        capitalLabel.text = "capital".localized(lang)
        longitudeLabel.text = "longitude".localized(lang)
        latitudeLabel.text = "latitude".localized(lang)
        mailLabel.text = "mail".localized(lang)
        addImageButton.setTitle("addImage".localized(lang), for: .normal)
        viewMoreButton.setTitle("viewMore".localized(lang), for: .normal)
        addVideoButton.setTitle("addVideo".localized(lang), for: .normal)
        playButton.setTitle("playVideo".localized(lang), for: .normal)
        saveButton.setTitle("save".localized(lang), for: .normal)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! String
        if mediaType == "public.movie" {
            print("Selected movie")
            let videoURL = info[.mediaURL] as! URL
            print(videoURL)
            let firebaseVideoPath = "videos/\(currentCity.ID!)/video.mp4"
            currentCity.video = firebaseVideoPath
            let videoRef = Storage.storage().reference().child(firebaseVideoPath)
            let metadata = StorageMetadata()
            metadata.contentType = "video/quicktime"
            if let videoData = NSData(contentsOf: videoURL) as Data? {
                videoRef.putData(videoData, metadata: metadata) { (data, err) in
                    if let myError = err {
                        print(myError)
                    }
                    
                    self.setVideo(self.currentCity)
                }
            }
            
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        let photoURL = info[.imageURL] as! URL
        print(photoURL)
        let image = info[.originalImage] as! UIImage
        photoView.image = image
        let firebaseImagePath = "images/\(currentCity.ID!)/\(currentCity.images.count)"
        let imageRef = Storage.storage().reference().child(firebaseImagePath)
        imageRef.putFile(from: photoURL, metadata: nil) { (data, err) in
            if let myError = err {
                print(myError)
            }
        }
        
        currentCity.images.append(firebaseImagePath)
        self.dismiss(animated: true, completion: nil)
    }
}
