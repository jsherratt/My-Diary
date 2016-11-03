//
//  NoteDetailViewController.swift
//  My Diary
//
//  Created by Joey on 02/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreLocation

class NoteDetailViewController: UIViewController, UITextViewDelegate {
    
    //---------------------
    //MARK: Variables
    //---------------------
    var note: Note?
    fileprivate let noteTextViewLimit = 300
    fileprivate var locationManager: LocationManager!
    fileprivate var location: CLLocation?
    fileprivate var imageData: Data?
    let coreDataManager = CoreDataManager.sharedInstance
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(withPresentingViewController: self)
        manager.delegate = self
        return manager
    }()

    //---------------------
    //MARK: Outlets
    //---------------------
    @IBOutlet weak var noteTextView: KMPlaceholderTextView!
    @IBOutlet weak var characterLimitLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise navigation bar
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = "\(dateFormatter.string(from: Date()))"
        
        //Round corners of image
        noteImageView.layer.cornerRadius = 5
        noteImageView.clipsToBounds = true
        
        if let note = self.note {
            
            configureViewWith(note: note)
        }
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    func configureViewWith(note: Note) {
        
        noteTextView.text = note.text
        
        updateCharacterLimitLabel()
        
        if let image = note.image {
            self.noteImageView.image = UIImage(data: image as Data)
            addImageButton.setTitle("Change Image", for: .normal)
        }
        
        if let location = note.location {
            
            addLocationButton.setTitle("Location", for: .normal)
            addLocationButton.isEnabled = false
            
            locationManager = LocationManager()
            
            let latitude = location.latitude
            let longitde = location.longitude
            
            let locationToReverse = CLLocation(latitude: latitude, longitude: longitde)
            
            locationManager.getPlacemark(forLocation: locationToReverse) { (originPlacemark, error) in
                
                if let error = error {
                    print(error)
                    
                } else if let placemark = originPlacemark {
                    
                    guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else { return }
                    
                    self.locationLabel.text = "\(name), \(city), \(area)"
                }
            }
        }
    }
    
    func addImageActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            
            self.mediaPickerManager.presentImagePickerController(animated: true, andSourceType: .camera)
        })
        actionSheet.addAction(camera)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            
            self.mediaPickerManager.presentImagePickerController(animated: true, andSourceType: .photoLibrary)
        })
        actionSheet.addAction(photoLibrary)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func updateCharacterLimitLabel() {
        
        let characterLimitCount = "\(noteTextView.text.characters.count)" + "/\(noteTextViewLimit)"
        let textToChange = "\(noteTextView.text.characters.count)"
        
        let range = (characterLimitCount as NSString).range(of: textToChange)
        let attributedString = NSMutableAttributedString(string: characterLimitCount)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 109/255.0, green: 152/255.0, blue: 93/255.0, alpha: 1), range: range)
        
        characterLimitLabel.attributedText = attributedString
    }
    
    //---------------------
    //MARK: Guesture Rec
    //---------------------
    @IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    //-----------------------
    //MARK: Buttons Actions
    //-----------------------
    @IBAction func addLocation(_ sender: UIButton) {
        
        locationLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        locationManager = LocationManager()
        locationManager.onLocationFix = { placemark, error in
            
            if let placemark = placemark {
                
                self.location = placemark.location
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.locationLabel.isHidden = false
                
                guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else { return }
                
                self.locationLabel.text = "Location - \(name), \(city), \(area)"
            }
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {

        addImageActionSheet()
    }
    
    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        
        guard let text = noteTextView.text, !noteTextView.text.isEmpty else { showAlert(with: "Error", andMessage: "You must enter some text"); return }
        
        if let note = self.note {
            
            note.text = text
            
            if let imageData = self.imageData {
                note.image = imageData as NSData
            }
            coreDataManager.saveContext()
        }else {
            coreDataManager.saveNote(withText: text, andImageData: self.imageData, andLocation: self.location)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancle(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //-------------------------
    //MARK: Text View Delegate
    //-------------------------
    
    //Update the characterLimitLabel when user is typing
    func textViewDidChange(_ textView: UITextView) {
        
        updateCharacterLimitLabel()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //Dismiss keyboard with "Done" button
        if text == "\n" {
            
            noteTextView.resignFirstResponder()
            return false
        }
        
        //Set character limit
        let currentText = textView.text ?? ""
        
        guard let stringRange = range.range(for: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.characters.count <= noteTextViewLimit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//---------------------
//MARK: Extension
//---------------------
extension NoteDetailViewController: MediaPickerManagerDelegate {
    
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        
        self.noteImageView.image = image
        self.imageData = UIImageJPEGRepresentation(image, 1.0)
        
        manager.dismissImagePickerController(animated: true)
    }
}













