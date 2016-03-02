//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Mykola Aleshchanov on 12/13/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
//

import UIKit

// MARK: TableViewController: UITableViewController

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    var studentLocations: [StudentLocation] = [StudentLocation]()
    @IBOutlet weak var activityView: UIView!
    
    @IBOutlet weak var studentLocationsTableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Create and set the logout button */
        self.parentViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        activitySpinner.startAnimating()
        ParseClient.sharedInstance().getStudentLocations() { studentLocations, error in
            dispatch_async(dispatch_get_main_queue(), {
                self.activitySpinner.stopAnimating()
            })
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                print("In MapViewController's viewWillAppear: There are \(studentLocations.count) student locations")
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentLocationsTableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
    
    // MARK: UITableViewController
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentLocationTableViewCell"
        let studentLocation = studentLocations[indexPath.row]
        print("In TableViewController: row is \(indexPath.row)")
        print("In TableViewController: location is \(studentLocation)")
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.imageView!.image = UIImage(named: "Pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("In TableViewController: there are \(studentLocations.count) locations")
        return studentLocations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let studentLocation = studentLocations[indexPath.row]
        if let toOpen = studentLocation.mediaURL {
            app.openURL(NSURL(string: toOpen)!)
        }

    }
    
    // MARK: Logout
    
    func logoutButtonTouchUp() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
