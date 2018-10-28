//
//  TransactionReceiptViewController.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import UIKit

class TransactionReceiptViewController: UIViewController {
    var parsedTx: String?
    var transaction: Transaction?
    var wallet: Wallet!
    var chain: Chain?
    var signedTx: SignedTransaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let chain = chain,
            let tx = parsedTx,
            let currencyWallet = wallet.wallets[chain] {
            
            if let transaction = currencyWallet.decode(tx: tx) {
                signedTx = currencyWallet.sign(tx: transaction)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShowQRViewController {
            if segue.identifier == "showSignedTXSegue" {
                vc.data = signedTx?.body ?? """
                0100000001a0d842523a3cc0db4f273c355333bf4757809c4e2bcc5e51f95088098cca8c0b010000006b483045022100fbaa0a07b1d3bc3f66d5baea04b6a7df48eafb5e8f9cbf5c9c8653864d8a56f302200b325c824c06202e387e079cc619b3de0683ba0502c1a9e83bc781b14509e2b40121033a117cc4d164984c1e8fb58f39f08a17a2e615d77d8f7a35a7d9cdeb9e93ef4cfeffffff03220200000000000017a9147082f74ca1e78cbc1c0cba2b661b85e28ae57086870000000000000000126a106f6d6e69000000000000001f03473bc08d360000000000001976a914f8435be12ad3dc98226581fcfde21912e9d9301c88ac00000000
                """
                vc.type = .SignedTransaction
            } else {
                
            }
        }
        
        if let txReceiptView = segue.destination as? TransactionDetailedViewController,
            let transaction = transaction {
            txReceiptView.transaction = transaction
        }
    }
}
