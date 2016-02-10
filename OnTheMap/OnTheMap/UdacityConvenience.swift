//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Mykola Aleshchanov on 12/3/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: POST Convenience Methods
    
    func createUdacitySession(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void){
        let jsonBody : [String: [String: AnyObject]] = [
            "udacity": [
                "username": username,
                "password": password
            ]
        ]
        self.taskForPOSTMethod("session", jsonBody: jsonBody) { (result, errorString) in
            if (result != nil) {
                print("Created udacity session: result is \(result)")
                if let accountDictionary = result[UdacityClient.JSONResponseKeys.Account] as AnyObject? {
                    if let userKey = accountDictionary["key"] as? String {
                        self.getUdacityStudent(userKey) { (result, error) in
                            if let udacityStudentData = result["user"] as AnyObject? {
                                let studentDictionary = [
                                    "last_name": udacityStudentData["last_name"] as! String,
                                    "first_name": udacityStudentData["first_name"] as! String,
                                    "userKey": userKey
                                ]
                                self.student = UdacityStudent(dictionary: studentDictionary)
                            }
                        }
                    }
                }
                if let sessionDictionary = result[UdacityClient.JSONResponseKeys.Session] as AnyObject? {
                    self.sessionID = sessionDictionary["id"] as? String
                }
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "Failed to create Udacity Session.")
            }
        }
    }

    
    func deleteSession(session: String, completionHandler: (result: Int?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        /* 2. Make the request */
        /* 3. Send the desired value(s) to completion handler */
        print("implement me: UdacityClient deleteSession")
    }
}