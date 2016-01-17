//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Mykola Aleshchanov on 12/3/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    
    /*
    Method: https://www.udacity.com/api/session
    Method Type: POST
    Required Parameters:
    udacity - (Dictionary) a dictionary containing a username (email) and password pair used for authentication
    username - (String) the username (email) for a Udacity student
    password - (String) the password for a Udacity student
    */
    struct Constants {
        // MARK: URL
        static let BaseURL : String = "https://www.udacity.com/api/"
        
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "session"
        static let Users = "users/{user_id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "user_id"
    }
    
    // MARK: Udacity Dictionary Keys
    struct ParameterKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let udacity = [String: String]()
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Session
        static let Account = "account"
        static let Session = "session"
        
        // MARK: Account
        static let User = "user"
        
        // MARK: User
        static let LastName = "last_name"
        static let FirstName = "first_name"
        static let NickName = "nickname"
        static let Email = "email"
        static let Location = "location"
        static let WebSite = "website_url"
        static let LinkedIn = "linkedin_url"
        
    }
}