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
    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Create and set the logout button */
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations() { studentLocations, error in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                print("In MapViewController's viewWillAppear: There are \(studentLocations.count) student locations")
                dispatch_async(dispatch_get_main_queue()) {
                    self.locationsTableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
    
    // MARK: UITableViewController
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationTableViewCell"
        let location = studentLocations[indexPath.row]
        print("In TableViewController: row is \(indexPath.row)")
        print("In TableViewController: location is \(location)")
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = location.firstName
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("In TableViewController: there are \(studentLocations.count) locations")
        return studentLocations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO
    }
    
    // MARK: Logout
    
    func logoutButtonTouchUp() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
