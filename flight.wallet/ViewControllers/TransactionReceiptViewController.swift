//
//  TransactionReceiptViewController.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import UIKit
import CoreBitcoin

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
        
        if let str = parsedTx, let currencyWallet = wallet.wallets[address.type] {
            
            print("wallet", currencyWallet)
            
            if let request = currencyWallet.decode(url: str) {
                let (address, value, _) = request
                let tx = currencyWallet.buildTx(from: self.address, to: address, value: value)
                
                self.transaction = tx
            } else if let transaction = currencyWallet.decode(tx: str) {
                print("ptx", transaction)
                
                self.transaction = transaction
            }
        
            self.signedTx = currencyWallet.sign(tx: transaction!)
            
            debug("signed", self.signedTx)
            self.isSigned = true
            
            self.detailedView.transaction = signedTx ?? transaction
            self.detailedView.updateLabels()
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
        if let vc = segue.destination as? ShowQRViewController {
    
            if signedTx == nil {
                showAlert(title: "Error", message: "Could not sign transaction!")
            }
    
            if segue.identifier == "showSignedTXSegue" {
                vc.data = signedTx!.body
                vc.type = .SignedTransaction
                
                let bitcoinWallet = wallet.wallets[.Bitcoin] as! BitcoinWallet

                bitcoinWallet.update(transaction: signedTx as! BTCTransaction)
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
