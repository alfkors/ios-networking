//
//  ParseStudentLocation.swift
//  OnTheMap
//
//  Created by Mykola Aleshchanov on 12/29/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
//

import UIKit

// MARK: - StudentLocation

struct StudentLocation {
    
    // MARK: Properties
    
    var createdAt = ""
    var firstName = ""
    var lastName = ""
    var latitude = 0.0
    var longitude = 0.0
    var mapString = ""
    var mediaURL: String? = nil
    var objectId = ""
    var uniqueKey = ""
    var updatedAt = ""
    
    // MARK: Initializers
    
    init(dictionary: [String : AnyObject]) {
        
        createdAt = dictionary["createdAt"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as? String
        objectId = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        updatedAt = dictionary["updatedAt"] as! String

    }
    
    static func studentLocationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        
        /* Iterate through array of dictionaries; each Movie is a dictionary */
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
    
}