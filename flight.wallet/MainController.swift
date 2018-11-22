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

class MainController: UIViewController {
    var wallet = Wallet.instance
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wallet.initCrypto()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return wallet.isLoaded
    }
    
    @IBAction func goToWallet(_ sender: Any) {
        wallet.loaded {
            self.performSegue(withIdentifier: "goToWallet", sender: nil)
        }
    }
}
