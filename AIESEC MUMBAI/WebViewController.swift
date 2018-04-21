//
//  WebViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 22/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import WebKit
import SwiftOverlays

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var link: String = "http://hub.myaiesec.in"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.showWaitOverlay()
        let url : NSURL! = NSURL(string: link)
        let req = NSURLRequest(url: url as URL)
        webView.load(req as URLRequest)
//         self.removeAllOverlays()
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.removeAllOverlays()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
