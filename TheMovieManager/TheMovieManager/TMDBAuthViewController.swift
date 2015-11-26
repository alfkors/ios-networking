//
//  TMDBAuthViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - TMDBAuthViewController: UIViewController

class TMDBAuthViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var webView: UIWebView!
    
    var urlRequest: NSURLRequest? = nil
    var requestToken: String? = nil
    var completionHandler : ((success: Bool, errorString: String?) -> Void)? = nil
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        self.navigationItem.title = "TheMovieDB Auth"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelAuth")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if urlRequest != nil {
            self.webView.loadRequest(urlRequest!)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let allowed = webView.request?.URL?.pathComponents?.contains("allow")
        if (allowed!) {
            self.dismissViewControllerAnimated(true, completion: {() -> Void in
                self.completionHandler!(success: true, errorString: nil)
            })
            print("webView did finish loading. URL: \(webView.request?.URL.debugDescription)")
        }
    }

    
    // MARK: Cancel Auth Flow
    
    func cancelAuth() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - TMDBAuthViewController: UIWebViewDelegate

extension TMDBAuthViewController: UIWebViewDelegate {
}