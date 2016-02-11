//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mykola Aleshchanov on 12/13/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
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

class MapViewController: UIViewController, MKMapViewDelegate {

    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Create and set the logout button */
        self.parentViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // Get an array of StudentLocation structs and use it to create and array of point annotations.
        ParseClient.sharedInstance().getStudentLocations() { studentLocations, error in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                print("In MapViewController's viewWillAppear: There are \(studentLocations.count) student locations")
                
                for studentLocation in studentLocations {
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(studentLocation.latitude)
                    let long = CLLocationDegrees(studentLocation.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = studentLocation.firstName
                    let last = studentLocation.lastName
                    let mediaURL = studentLocation.mediaURL
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                // When the array is complete, we add the annotations to the map.
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(annotations)
                }
            } else {
                print(error)
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
        let sessionID = UdacityClient.sharedInstance().sessionID!
        UdacityClient.sharedInstance().deleteSession(sessionID){ (success, errorString) in
            if success {
                print("Logged out")
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                print("Error logging out")
            }
        }
    }
}