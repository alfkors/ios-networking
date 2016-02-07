//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by Mykola Aleshchanov on 12/5/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
//

import UIKit

// MARK: - UdacityStudent

struct UdacityStudent {
    
    // MARK: Properties
    
    var firstName = ""
    var lastName = ""
    /*var nickname = ""
    var location: AnyObject
    var website = ""
    var linkedin = ""*/
    
    // MARK: Initializers
    
    /* Construct a UdacityStudent from a dictionary */
    init(dictionary: [String:AnyObject]) {
        
        firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as! String
    }
}
