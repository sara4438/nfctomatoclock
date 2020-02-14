//
//  TomatoWebViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/29.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit
import WebKit

class TomatoWebViewController: UIViewController {

 var mWebView: WKWebView? = nil
//    @IBOutlet weak var mBackBtn: UIButton!
//    @IBOutlet weak var mForwardBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "http://34.85.51.56/charts/\(userId)"
        loadURL(urlString: url)
        
    }
    
    private func loadURL(urlString: String) {
        let url = URL(string: urlString)
        if let url = url {
//            mBackBtn.isEnabled = false
//            mForwardBtn.isEnabled = false
            let request = URLRequest(url: url)
            // init and load request in webview.
            mWebView = WKWebView(frame: self.view.frame)
//            mWebView?.frame.origin.y = mBackBtn.frame.origin.y + CGFloat(40)
            if let mWebView = mWebView {
                mWebView.navigationDelegate = self
                mWebView.load(request)
                self.view.addSubview(mWebView)
                self.view.sendSubviewToBack(mWebView)
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        if mWebView?.goBack() == nil {
            print("No more page to back")
        }

    }
    
    @IBAction func forwardAction(_ sender: UIButton) {
        if mWebView?.goForward() == nil {
            print("No more page to forward")
        }
    }
}


extension TomatoWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        if mWebView != nil {
//            mForwardBtn.isEnabled = webView.canGoForward
//            mBackBtn.isEnabled = webView.canGoBack
        }
    }
}
