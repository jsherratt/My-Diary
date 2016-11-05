//
//  PreviewViewController.swift
//  My Diary
//
//  Created by Joey on 05/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreLocation

class PreviewViewController: UIViewController {
    
    //---------------------
    //MARK: Variables
    //---------------------
    var note: Note?
    let coreDataManager = CoreDataManager.sharedInstance
    var locationManager: LocationManager?
    
    //Delete note preview action
    var previewActions: [UIPreviewActionItem] {
        
        let item1 = UIPreviewAction(title: "DeleteNote", style: .default) { (action, vc) in
            
            if let note = self.note {
                self.coreDataManager.deleteNote(note: note)
            }
        }
        return [item1]
    }
    
    //---------------------
    //MARK: Outlets
    //---------------------
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise navigation bar
        navigationItem.title = "Note Preview"
        
        //Position label text top left
        locationLabel.sizeToFit()
        
        //Check if note exists
        if let note = self.note {
            configureViewWith(note: note)
        }
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    func configureViewWith(note: Note) {
        
        textView.text = note.text
        
        if let image = note.image {
            imageView.image = UIImage(data: image as Data)
        }
        
        if let location = note.location {
            
            locationManager = LocationManager()
            
            let latitude = location.latitude
            let longitde = location.longitude
            
            let locationToReverse = CLLocation(latitude: latitude, longitude: longitde)
            
            locationManager?.getPlacemark(forLocation: locationToReverse) { (originPlacemark, error) in
                
                if let error = error {
                    print(error)
                    
                } else if let placemark = originPlacemark {
                    
                    guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else { return }
                    
                    self.locationLabel.text = "Location\n \(name), \(city), \(area)"
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
