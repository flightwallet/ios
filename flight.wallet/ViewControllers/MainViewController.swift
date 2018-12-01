//
//  MainViewController.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 25/11/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var wallet = Wallet.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wallet.initCrypto()
        
        wallet.loaded {
            print("loaded!")
            print(self.wallet.getAddresses())
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return wallet.isLoaded
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ScanQRViewController {
            vc.wallet = wallet
            let btcWallet = wallet.wallets[.Bitcoin] as! BitcoinWallet
            vc.address = btcWallet.generateAddress(index: 1)
        } else if let vc = segue.destination as? WalletViewController {
//            vc.wallet = wallet
        }
    }
    
    @IBAction func updateAccount(_ sender: Any) {
        guard let address = wallet.wallets[.Bitcoin]?.addresses.first else {
            return
        }
        
        let syncAccountURL = "https://flightwallet.org/sync/?chain=bitcoin&address=\(address.body ?? "")"
        
        let url = URL(string: syncAccountURL)!
        
        UIApplication.shared.openURL(url)
    }
}
