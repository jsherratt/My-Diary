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
    fileprivate let noteTextViewLimit = 200
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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTextView: KMPlaceholderTextView!
    @IBOutlet weak var characterLimitLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise navigation bar
        navigationController?.navigationBar.tintColor = UIColor.white
        
        dateLabel.text = "Date - \(dateFormatter.string(from: Date()))"
        
        noteImageView.layer.cornerRadius = 5
        noteImageView.clipsToBounds = true
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

        mediaPickerManager.presentImagePickerController(animated: true)
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
    
    //-------------------------
    //MARK: Text View Delegate
    //-------------------------
    
    //Update the characterLimitLabel when user is typing
    func textViewDidChange(_ textView: UITextView) {
        
         characterLimitLabel.text = "\(noteTextView.text.characters.count)/\(noteTextViewLimit)"
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

extension NoteDetailViewController: MediaPickerManagerDelegate {
    
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        
        self.noteImageView.image = image
        self.imageData = UIImageJPEGRepresentation(image, 1.0)
        
        manager.dismissImagePickerController(animated: true)
    }
    
}













