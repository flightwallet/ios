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
        
        print("chain", chain)
        print("tx", parsedTx)
        
        wallet = Wallet.instance
        chain = .Bitcoin
        
        if let tx = parsedTx, let currencyWallet = wallet.wallets[chain!] {
            
            print("wallet", currencyWallet)
            
            if let transaction = currencyWallet.decode(tx: tx) {
                print("ptx", transaction)
                
                self.transaction = transaction
                self.signedTx = currencyWallet.sign(tx: transaction)
                
                print("signed", self.signedTx)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShowQRViewController {
            if segue.identifier == "showSignedTXSegue" {
                vc.data = signedTx!.body
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
