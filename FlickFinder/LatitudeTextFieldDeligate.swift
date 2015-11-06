//
//  LatitudeTextFieldDeligate.swift
//  FlickFinder
//
//  Created by Mykola Aleshchanov on 11/5/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
//

import Foundation
import UIKit

class LatitudeTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if((textField.text! as NSString).floatValue >= -90.0 && (textField.text! as NSString).floatValue <= 90.0){
            return true
        } else {
            return false
        }
    }
}