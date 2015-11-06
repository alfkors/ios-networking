//
//  FreeTextTextFieldDelegate.swift
//  FlickFinder
//
//  Created by Mykola Aleshchanov on 11/5/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
//

import Foundation
import UIKit

class FreeTextTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
