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
    
    func roundImage() {
        
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}
