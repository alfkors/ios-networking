//
//  ViewController.swift
//  FlickFinder
//
//  Created by Mykola Aleshchanov on 10/27/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
//

import UIKit

let BASE_URL: String = "https://api.flickr.com/services/rest/"
let DATA_FORMAT: String = "json"
let API_KEY: String = "6da082d468c576c8f648938f50aa17d7"
let EXTRAS: String = "url_m"
let SEARCH_TEXT: String = "mime"
let NO_JSON_CALLBACK = "1"

class ViewController: UIViewController {
    
    let methodParams = [
        "method" : "flickr.photos.search",
        "api_key" : API_KEY,
        "text" : SEARCH_TEXT,
        "extras": EXTRAS,
        "format" : DATA_FORMAT,
        "nojsoncallback" : NO_JSON_CALLBACK
    ]

    @IBOutlet weak var flickImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var flickName: UILabel!

    @IBAction func searchByTextButton(sender: AnyObject) {
        var searchUrlString = "\(BASE_URL)"
        searchUrlString += "?method=" + methodParams["method"]!
        searchUrlString += "&api_key=" + methodParams["api_key"]!
        searchUrlString += "&text=" + methodParams["text"]!
        searchUrlString += "&extras=" + methodParams["extras"]!
        searchUrlString += "&format=" + methodParams["format"]!
        searchUrlString += "&nojsoncallback=" + methodParams["nojsoncallback"]!
        
        var flickName: String!
        var flickImage: UIImage?
        let searchSession = NSURLSession.sharedSession()
        let searchUrl = NSURL(string: searchUrlString)
        let searchRequest = NSURLRequest(URL: searchUrl!)
        let task = searchSession.dataTaskWithRequest(searchRequest){ (data, response, error) in
            if (error == nil){
                let parsedResult = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                let photos = parsedResult!["photos"] as! NSDictionary
                let photoArray = photos["photo"] as! NSArray
                if(photoArray.count > 0){
                    let photoArray = photos["photo"] as! NSArray
                    let photo = photoArray[Int(arc4random_uniform(UInt32(photoArray.count)))]
                    let flickUrlString = photo.valueForKey("url_m") as! String
                    let flickUrl = NSURL(string: flickUrlString)
                    let flickData = NSData(contentsOfURL: flickUrl!)
                    flickImage = UIImage(data: flickData!)
                    flickName = photo.valueForKey("title") as! String
                } else {
                    flickName = "No Image Found"
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.flickImage.image = flickImage
                    self.flickName.text = flickName
                })

            } else {
                print("Error is \((error! as NSError).code)")
            }
        }
        
        task.resume()
    }
    
    @IBAction func searchByCoordinatesButton(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

