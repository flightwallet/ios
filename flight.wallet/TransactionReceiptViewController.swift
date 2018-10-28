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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let chain = chain,
            let tx = parsedTx,
            let currencyWallet = wallet.wallets[chain] {
            transaction = currencyWallet.decode(tx: tx)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let transaction = transaction,
//            let txReceiptView = segue.destination as? TransactionDetailedViewController {
//            txReceiptView.transaction = transaction
//        } else {
//            
//        }
    }
}
