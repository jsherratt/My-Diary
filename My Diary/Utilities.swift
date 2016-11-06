//
//  Utilities.swift
//  My Diary
//
//  Created by Joey on 01/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

//---------------------
//MARK: Extensions
//---------------------
extension UIImageView {
    
    //Round image for table view
    func roundImage() {
        
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}

extension NSRange {
    
    //Helper for character limit
    func range(for str: String) -> Range<String.Index>? {
        
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}

extension UIViewController {
    
    //Show alert with a title and message
    func showAlert(with title: String, andMessage message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

//----------------------
//MARK: Date Formatter
//----------------------
let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.full
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    return dateFormatter
}()
