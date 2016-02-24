//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mykola Aleshchanov on 12/3/15.
//  Copyright © 2015 Mykola Aleshchanov. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    var session: NSURLSession!
    var student: UdacityStudent!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.debugTextLabel.text = ""
    }
    
    // MARK: Actions
    
    @IBAction func login(sender: AnyObject) {
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayError("Username or Password is Empty")
        } else {
            print("Username is: \(usernameTextField.text), password is: \(passwordTextField.text)")
            
            activitySpinner.startAnimating()
            
            UdacityClient.sharedInstance().createUdacitySession(usernameTextField.text!, password: passwordTextField.text!) { (success, errorString) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.activitySpinner.stopAnimating()
                })
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }

    // MARK: LoginViewController
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    // MARK: Modify UI
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController()
            let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default) { action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(dismissAction)
            alertController.title = "Error"
            if let errorString = errorString {
                alertController.message = errorString
            }
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
}
