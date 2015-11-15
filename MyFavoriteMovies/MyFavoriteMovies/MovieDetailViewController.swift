//
//  MovieDetailViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: MovieDetailViewController: UIViewController

class MovieDetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var unFavoriteButton: UIButton!

    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var movie: Movie?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        /* TASK A: Get favorite movies, then update the favorite buttons */
        /* 1A. Set the parameters */
        let methodParameters = [
            "api_key": appDelegate.apiKey as AnyObject,
            "session_id": appDelegate.sessionID as! AnyObject
        ]
        /* 2A. Build the URL */
        let urlString = appDelegate.baseURLSecureString + "account/\(appDelegate.userID)/favorite/movies" + appDelegate.escapedParameters(methodParameters)
        print("Get favorite movies urlString \(urlString)")
        let url = NSURL(string: urlString)!
        /* 3A. Configure the request */
        let request = NSURLRequest(URL: url)
        /* 4A. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, downloadError) in
            /* 5A. Parse the data */
            if let parsedData = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary {
                /* 6A. Use the data! */
                let results = parsedData["results"] as! [[String : AnyObject]]
                let favoriteMovies = Movie.moviesFromResults(results)
                if (favoriteMovies.contains({$0.title == self.movie?.title})) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.favoriteButton.hidden = true
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.unFavoriteButton.hidden = true
                    }
                }
            }
        }
        
        /* 7A. Start the request */
        task.resume()
        /* TASK B: Get the poster image, then populate the image view */
        if let movie = movie, posterPath = movie.posterPath {
            
            /* 1B. Set the parameters */
            // There are none...
            
            /* 2B. Build the URL */
            let baseURL = NSURL(string: appDelegate.config.baseImageURLString)!
            let url = baseURL.URLByAppendingPathComponent("w342").URLByAppendingPathComponent(posterPath)
            
            /* 3B. Configure the request */
            let request = NSURLRequest(URL: url)
            
            /* 4B. Make the request */
            let task = session.dataTaskWithRequest(request) { (data, response, error) in
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    print("There was an error with your request: \(error)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    if let response = response as? NSHTTPURLResponse {
                        print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    } else if let response = response {
                        print("Your request returned an invalid response! Response: \(response)!")
                    } else {
                        print("Your request returned an invalid response!")
                    }
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                
                /* 5B. Parse the data */
                // No need, the data is already raw image data.
                
                /* 6B. Use the data! */
                if let image = UIImage(data: data) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.posterImageView!.image = image
                    }
                } else {
                    print("Could not create image from \(data)")
                }
            }
            
            /* 7B. Start the request */
            task.resume()
        }
    }
    
    // MARK: Favorite Actions
    
    @IBAction func unFavoriteButtonTouchUpInside(sender: AnyObject) {
        
        /* TASK: Remove movie as favorite, then update favorite buttons */
        
        let postBody = [
            "media_type": "movie",
            "media_id": movie!.id,
            "favorite": false
        ]
        let jsonPostData = try? NSJSONSerialization.dataWithJSONObject(postBody, options: NSJSONWritingOptions(rawValue: 0))
        let jsonPostText = NSString(data: jsonPostData!, encoding: NSASCIIStringEncoding)
        print("unFavorite post json text: \(jsonPostText!)")
        /* 1A. Set the parameters */
        let methodParameters = [
            "api_key": appDelegate.apiKey as AnyObject,
            "session_id": appDelegate.sessionID as! AnyObject
        ]
        /* 2A. Build the URL */
        let urlString = appDelegate.baseURLSecureString + "account/\(appDelegate.userID)/favorite" + appDelegate.escapedParameters(methodParameters)
        print("favorite another movie urlString \(urlString)")
        let url = NSURL(string: urlString)!
        /* 3A. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("applicaiton/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.HTTPBody = jsonPostData
    
        /* 2. Build the URL */
        /* 3. Configure the request */
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let response = response, data = data {
                print("unFavorite response: \(response)")
                print(String(data: data, encoding: NSUTF8StringEncoding))
                let parsedData = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                if(parsedData!["status_code"] as! Int == 13) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.favoriteButton.hidden = false
                        self.unFavoriteButton.hidden = true
                    }
                }
            } else {
                print(error)
            }
        }
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
        task.resume()
    }
    
    @IBAction func favoriteButtonTouchUpInside(sender: AnyObject) {
        
        /* TASK: Remove movie as favorite, then update favorite buttons */
        
        let postBody = [
            "media_type": "movie",
            "media_id": movie!.id,
            "favorite": true
        ]
        let jsonPostData = try? NSJSONSerialization.dataWithJSONObject(postBody, options: NSJSONWritingOptions(rawValue: 0))
        let jsonPostText = NSString(data: jsonPostData!, encoding: NSASCIIStringEncoding)
        print("Favorite post json text: \(jsonPostText!)")
        /* 1A. Set the parameters */
        let methodParameters = [
            "api_key": appDelegate.apiKey as AnyObject,
            "session_id": appDelegate.sessionID as! AnyObject
        ]
        /* 2A. Build the URL */
        let urlString = appDelegate.baseURLSecureString + "account/\(appDelegate.userID)/favorite" + appDelegate.escapedParameters(methodParameters)
        print("favorite another movie urlString \(urlString)")
        let url = NSURL(string: urlString)!
        /* 3A. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("applicaiton/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.HTTPBody = jsonPostData
        
        /* 2. Build the URL */
        /* 3. Configure the request */
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let response = response, data = data {
                print("unFavorite response: \(response)")
                print(String(data: data, encoding: NSUTF8StringEncoding))
                let parsedData = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                if(parsedData!["status_code"] as! Int == 1 || parsedData!["status_code"] as! Int == 12) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.favoriteButton.hidden = true
                        self.unFavoriteButton.hidden = false
                    }
                }
            } else {
                print(error)
            }
        }
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
        task.resume()

    }
}
