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
    var address: Address!
    var chain: Chain?
    var signedTx: SignedTransaction?
    var detailedView: TransactionDetailedViewController!
    
    var isSigned = false {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debug("chain", chain)
        debug("tx", parsedTx)
        
        
//        wallet = Wallet.instance
        
        if let tx = parsedTx, let currencyWallet = wallet.wallets[address.type] {
            
            print("wallet", currencyWallet)
            
            if let transaction = currencyWallet.decode(tx: tx) {
                print("ptx", transaction)
                
                self.transaction = transaction
                self.signedTx = currencyWallet.sign(tx: transaction)
                
                debug("signed", self.signedTx)
                self.isSigned = true
                
                self.detailedView.transaction = signedTx ?? transaction
                self.detailedView.updateLabels()
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showSignedTXSegue" {
            return self.signedTx != nil
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if signedTx == nil {
            showAlert(title: "Error", message: "Could not sign transaction!")
        }
        
        if let vc = segue.destination as? ShowQRViewController {
            if segue.identifier == "showSignedTXSegue" {
                vc.data = signedTx!.body
                vc.type = .SignedTransaction
            } else {
                
            }
        }
        
        if let txReceiptView = segue.destination as? TransactionDetailedViewController {
            self.detailedView = txReceiptView
            self.detailedView.transaction = signedTx ?? transaction
            self.detailedView.wallet = wallet
            self.detailedView.address = address
        }
    }
}
