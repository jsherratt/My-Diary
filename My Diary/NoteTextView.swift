//
//  NoteTextView.swift
//  My Diary
//
//  Created by Joey on 02/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class NoteTextView: UITextView {

    override func draw(_ rect: CGRect) {
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2.5
        self.layer.borderColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0).cgColor
    }
}
