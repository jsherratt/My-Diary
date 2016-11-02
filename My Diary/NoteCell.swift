//
//  NoteCell.swift
//  My Diary
//
//  Created by Joey on 01/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    //---------------------
    //MARK: Outlets
    //---------------------
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //---------------------
    //MARK: Functions
    //---------------------
//    func configureCellWithNote(note: Note) {
//        
//        
//    }

}