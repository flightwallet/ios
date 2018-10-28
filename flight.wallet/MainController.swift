//
//  MainController.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import UIKit
import WebKit

protocol JSEngine {
    func runJS(code: String, completion: @escaping (Any?, Error?) -> ())
}

class MainController: UIViewController {
    var wallet = Wallet.instance
 
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let insets = UIEdgeInsets(top: 20, left: 0, bottom: 60, right: 0)

        webView = WKWebView(frame: view.frame.insetBy(dx: 0, dy: 60))
        
        webView.isUserInteractionEnabled = true
        
        view.addSubview(webView)
        view.sendSubview(toBack: webView)
//
//        let js =
//"""
//        window.onload = async () => {
//            const balance = await web3.eth.getBalance("0x17dA6A8B86578CEC4525945A355E8384025fa5Af")
//
//            alert(1)
//            window.webkit.messageHandlers.updateApplicationState.postMessage(balance.toNumber())
//        }
//"""
//        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//
//        webView.configuration.userContentController.addUserScript(script)
//
        webView.configuration.userContentController.add(self, name: "updateApplicationState")
         webView.configuration.userContentController.add(self, name: "jsHandler")
        
        let bundleURL = Bundle.main.resourceURL!.absoluteURL
        let html = bundleURL.appendingPathComponent("index.html")
        webView.loadFileURL(html, allowingReadAccessTo:bundleURL)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return wallet.isLoaded
    }
    
    @IBAction func goToWallet(_ sender: Any) {
        wallet.initCrypto(jsEngine: self)
        wallet.loaded {
            self.performSegue(withIdentifier: "goToWallet", sender: nil)
        }
    }
}

extension MainController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("received message \(message)")
        
        if message.name == "jsHandler" {
            print(message.body)
        }
        
        if message.name == "updateApplicationState" {
            print(message.body)
        }
    }
}

extension MainController: JSEngine {
    func runJS(code: String, completion: @escaping (Any?, Error?) -> ()) {
        webView.evaluateJavaScript(code) {
            result, error in
            print("JS Code \(result), \(error)")
            completion(result, error)
        }
    }
}
