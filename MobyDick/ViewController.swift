//
//  ViewController.swift
//  MobyDick
//
//  Created by Jason Gresh on 1/6/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate, UITextFieldDelegate {
    var webView: WKWebView!
    let divColors = ["red", "green", "blue", "purple"]
 
    @IBOutlet weak var reloadButton: UIBarButtonItem!
       @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var wordToReplace: UITextField!
    @IBOutlet weak var replacementWord: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
    
        let path = Bundle.main.path(forResource: "embedded", ofType: "html")
        let dir = URL(fileURLWithPath: Bundle.main.bundlePath)
        let myURL = URL(fileURLWithPath: path!)
        webView.loadFileURL(myURL, allowingReadAccessTo: dir)
    }

    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        // Read js to INJECT from a file because there will be quite a bit of it
        let jsPath = Bundle.main.path(forResource: "inject", ofType: "js")
        let myURL = URL(fileURLWithPath: jsPath!)
        if let javascript = try? String(contentsOf: myURL) {
            let userScript = WKUserScript(source: javascript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            
            // inject some scripts
            userContentController.addUserScript(userScript)
        }
        
        // self conforms to protocol WKScriptMessageHandler
        // NOTE: We're not using this messaging for the homework but I leave it in for
        // future use and reference.
        userContentController.add(self, name: "runSwift")
        webConfiguration.userContentController = userContentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        
        if let containerView = view.viewWithTag(1) {
            containerView.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        }
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func reload(_ sender: Any) {
        webView.reload()
    }
  
    
   //My attempt at swapping out words
    @IBAction func swapWords(_ sender: UIButton) {
        let text = "document.body."
//        var a = "The quick brown fox jumped over the lazy dog.";
//        
//        var pattern = /the/ig; // notice "g" here now!
//        
//        a.replace( pattern, "THE" )
//        let js = for(i; i < strLength; i++) {
//         str = str.replace('\((wordToReplace.text))'
//         , '\(replacementWord.text))'
//         }
//        
//        webView.evaluateJavaScript(js) { (ret, error) in
//                print(ret ?? "whoops")
//        }
//    }
    
    // I've taken the div squares out of the HTML document so this segmented control currently does nothing.
    // Repurpose it to change the background color of the document
    //
    // to change the background color of the document
    @IBAction func colorChosen(_ sender: UISegmentedControl) {
        let color = divColors[sender.selectedSegmentIndex]
        let js = "document.body.style.backgroundColor = '\(color)';";
        webView.evaluateJavaScript(js) { (ret, error) in
            print(ret ?? "whoops")
        }
    }
    
    // Not using this for this Homework assignment
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Received message named: \(message.name)")
        print(message.body)
        
        if let msg = message.body as? [String:Any] {
            print(msg["color"] ?? "No color")
            print(msg["width"] ?? "No width")
        }
    }
}
