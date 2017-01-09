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

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var newWord: UITextField!
    @IBOutlet weak var oldWord: UITextField!
    @IBOutlet weak var changeWordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        let path = Bundle.main.path(forResource: "embedded", ofType: "html")
        let dir = URL(fileURLWithPath: Bundle.main.bundlePath)
        let myURL = URL(fileURLWithPath: path!)
        webView.loadFileURL(myURL, allowingReadAccessTo: dir)
        webView.navigationDelegate = self
        
        
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
    

    @IBAction func backButton(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func forwardButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func colorChosen(_ sender: UISegmentedControl) {
        let color = divColors[sender.selectedSegmentIndex]
        
        var js = "document.getElementById('moby-color').style.backgroundColor = '\(color)';";
        js += "document.getElementById('box').innerHTML = '\(color)'"
        webView.evaluateJavaScript(js) { (ret, error) in
            print(ret ?? "whoops")
        }
    }
    
    @IBAction func changeWord(_ sender: Any) {
        print(oldWord.text!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case oldWord:
                print(oldWord.text!)
        case newWord:
            print(newWord.text!)
        default:
            break
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
