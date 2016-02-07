//
//  SubmitStudentLocationViewController.swift
//  OnTheMap
//
//  Created by Mykola Aleshchanov on 2/2/16.
//  Copyright © 2016 Mykola Aleshchanov. All rights reserved.
//

import UIKit
import MapKit

/**
 * This view controller displays pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class SubmitStudentLocationViewController: UIViewController, MKMapViewDelegate {
    
    var studentLocationCoordinate: CLLocationCoordinate2D!
    var studentLocation: StudentLocation!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var studentLinkTextField: UITextField!
    
    @IBAction func submitButton(sender: UIButton) {
        /*
        Steps to submit a new Student Location:
        1. GeoCode location text string
        2. Update map view with the new location
        3. Create a new Student Location Object
        4. Post the new Student Location Object to Parse
        */
        
        let newStudentDictionary = [
            "createdAt" : "2016-02-3T22:27:14.456Z",
            "firstName" : "Jessica",
            "lastName" : "Uelmen",
            "latitude" : 28.1461248,
            "longitude" : -82.75676799999999,
            "mapString" : "Tarpon Springs, FL",
            "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
            "objectId" : "kj18GEaWD8",
            "uniqueKey" : 872458750,
            "updatedAt" : "2015-03-09T22:07:09.593Z"
        ]
        

        var annotations = [MKPointAnnotation]()
        let firstName = (UdacityClient.sharedInstance().student?.firstName)! as String
        let lastName = (UdacityClient.sharedInstance().student?.lastName)! as String
        let mediaURL = studentLinkTextField.text
        
        print("In getStudentLocation completion handler: \(firstName) \(lastName)")
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = studentLocationCoordinate
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaURL
        
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        // When the array is complete, we add the annotations to the map.
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.addAnnotations(annotations)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Create and set the logout button */
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func geoCodeStudentLocation(studentLocation: String, completionHandler: (coordinate: CLLocationCoordinate2D?, errorString: String?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(studentLocation) { (placemark, error) in
            print("GeoCoding \(studentLocation)")
            if let placemark = placemark {
                print("geoCoder has placemark")
                completionHandler(coordinate: placemark[0].location?.coordinate, errorString: nil)
            } else {
                print("geoCoder error: \(error)")
                completionHandler(coordinate: nil, errorString: "Error geoCoding student location")
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    // MARK: Logout
    
    func logoutButtonTouchUp() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}