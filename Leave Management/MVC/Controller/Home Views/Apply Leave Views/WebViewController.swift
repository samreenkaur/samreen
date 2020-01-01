//
//  WebViewController.swift
//  Leave Management
//
//  Created by osx on 01/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate {

    //MARK: - outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    
    //MARK:- Lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.callViewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        if let pdf = Bundle.main.url(forResource: "Company Policies", withExtension: "docx", subdirectory: nil, localization: nil)  {
            let req = URLRequest(url: pdf)
            webView.load(req)
        }
//        let url = URL(string: "https://www.google.com")
//        webView.load(URLRequest(url: url!))
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
    }
    private func callViewWillLoad()
    {
        
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "Leave Policies"
    }
    
    
    
    //MARK: - webView delegates
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("loading")
        self.loader.isHidden = false
        
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("added")
        self.loader.isHidden = true
    }
    
}



