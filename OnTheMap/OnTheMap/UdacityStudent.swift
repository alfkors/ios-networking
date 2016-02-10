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
    
    var firstName:String!
    var lastName:String!
    var lattitude:Double?
    var longitude:Double?
    var mediaURL:String?
    var userKey:String!
    var mapString:String?
    
    // MARK: Initializers
    
    /* Construct a UdacityStudent from a dictionary */
    init(dictionary: [String:AnyObject]) {
        
        firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as! String
        lattitude = dictionary["lattitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mediaURL = dictionary["mediaURL"] as? String
        mapString = dictionary["mapString"] as? String
        userKey = dictionary["userKey"] as! String
    }
    
    func toDictionary() -> [String:AnyObject] {
        
        let udacityStudentDictionary : [String:AnyObject] = [
            "firstName" : self.firstName,
            "lastName" : self.lastName,
            "latitude" : self.lattitude!,
            "longitude" : self.longitude!,
            "mapString" : self.mapString!,
            "mediaURL" : self.mediaURL!,
            "uniqueKey" : self.userKey
            ]
        return udacityStudentDictionary
    }
}
