//
//  NewStudentLocationViewController.swift
//  OnTheMap
//
//  Created by Mykola Aleshchanov on 1/22/16.
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

class NewStudentLocationViewController: UIViewController, MKMapViewDelegate {
    
    var studentLocationCoordinate: CLLocationCoordinate2D!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! SubmitStudentLocationViewController
        controller.studentLocationCoordinate = self.studentLocationCoordinate
    }
    
    @IBOutlet weak var studentLocationTextField: UITextField!
    @IBAction func submitButton(sender: UIButton) {
        /*
            1. GeoCode location text string
            2. Pass the annotations array to the submit view via segue
        */
        
        if studentLocationTextField.text != "" {
            geoCodeStudentLocation(studentLocationTextField.text!) { (coordinate, error) in
                if let studentLocationCoordinate = coordinate {
                    self.studentLocationCoordinate = studentLocationCoordinate
                    self.performSegueWithIdentifier("submitStudentLocation", sender: self)
                } else {
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Create and set the logout button */
        self.parentViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
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
    
    // MARK: Logout
    
    func logoutButtonTouchUp() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}