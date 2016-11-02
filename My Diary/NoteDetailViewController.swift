//
//  NoteDetailViewController.swift
//  My Diary
//
//  Created by Joey on 02/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController, UITextViewDelegate {
    
    //---------------------
    //MARK: Variables
    //---------------------
    let noteTextFieldLimit = 200

    //---------------------
    //MARK: Outlets
    //---------------------
    @IBOutlet weak var noteTextView: NoteTextView!
    @IBOutlet weak var characterLimitLabel: UILabel!
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise navigation bar
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //Set note text view placeholder text
        noteTextView.text = "Record your thoughts for today"
        noteTextView.textColor = UIColor.lightGray
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noteTextView.setContentOffset(CGPoint.zero, animated: false)
        noteTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    //---------------------
    //MARK: Text View
    //---------------------
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if noteTextView.textColor == UIColor.lightGray {
            noteTextView.text = nil
            noteTextView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        
        guard let stringRange = range.range(for: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        characterLimitLabel.text = "\(noteTextView.text.characters.count)/\(noteTextFieldLimit)"
        
        return changedText.characters.count <= noteTextFieldLimit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
