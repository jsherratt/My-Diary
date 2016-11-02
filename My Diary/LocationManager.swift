//
//  LocationManager.swift
//  My Diary
//
//  Created by Joey on 02/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    //---------------------
    //MARK: Variables
    //---------------------
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var onLocationFix: ((CLPlacemark?, Error?) -> Void)?
    
    //---------------------
    //MARK: Init
    //---------------------
    override init() {
        super.init()
        
        manager.delegate = self
        
        //Get user permission
        getPermission()
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    fileprivate func getPermission() {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
}

//---------------------
//MARK: Extension
//---------------------
extension LocationManager: CLLocationManagerDelegate {
    
    //------------------------
    //MARK: Location Delegate
    //------------------------
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if let onLocationFix = self.onLocationFix {
                onLocationFix(placemarks?.first, error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Unresolved error: \(error)")
    }
}
