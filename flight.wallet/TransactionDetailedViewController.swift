//
//  TransactionViewController.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import UIKit

class TransactionDetailedViewController: UITableViewController {
    var wallet: Wallet!
    var address: Address!
    
    var transaction: Transaction? {
        didSet {
            updateLabels()
        }
    }
    
    var isGood: Bool {
        return transaction != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }
    
    func updateLabels () {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canPerformAction action:
        Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if (action.description == "copy:") {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        
        var cellText: String?
        
        let change = transaction?.estimateChange(ownerAddress: address) ?? 0
        let amount = transaction?.estimateAmount(ownerAddress: address) ?? 0
        
        switch(indexPath.section) {
            case 0: cellText = transaction?.tx_inputs?[indexPath.row].text
            case 1: cellText = transaction?.tx_outputs?[indexPath.row].address?.body
            case 2: cellText = String(amount)
            case 3: cellText = String(change)
            default: cellText = ""
        }
        
        if (action.description == "copy:") {
            UIPasteboard.general.string = cellText
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Inputs (txhash:index)"
        case 1: return "Outputs (addresses you pay)"
        case 2: return "Total"
        case 3: return "Change (will return to your wallet)"
        default:
            return ""
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return transaction?.tx_inputs?.count ?? 0
        case 1: return transaction?.tx_outputs?.count ?? 0
        case 2: return 2
        case 3: return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionInputCell") as? TransactionInputTableViewCell else {
                fatalError("Can't dequeue cell")
            }
            
            guard let input = transaction?.tx_inputs?[indexPath.row] else {
                return cell
            }
            
            cell.setData(input)
            
            return cell
            
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionOutputCell") as? TransactionOutputTableViewCell else {
                fatalError("Can't dequeue cell")
            }
            
            guard let output = transaction?.tx_outputs?[indexPath.row] else {
                return cell
            }
            
            let isMyAddress = output.address != nil && output.address! == address
            
            cell.setData(output, isMyAddress: isMyAddress)
            
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionAmountCell") as? TransactionAmountTableViewCell else {
                fatalError("Can't dequeue cell")
            }
            
            
            let change = transaction?.estimateChange(ownerAddress: address) ?? 0
            let amount = transaction?.estimateAmount(ownerAddress: address) ?? 0
            
            
            if (indexPath.row == 0) {
            
                let text = "Sending: " + String(amount) + " BTC"
                
                cell.setData(amount: text)
                
            } else {
                
                let text = "Change: " + String(change) + " BTC"
                
                cell.setData(amount: text)
                
            }
            
            return cell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionAmountCell") as? TransactionAmountTableViewCell else {
                fatalError("Can't dequeue cell")
            }
        
            let change = transaction?.estimateChange(ownerAddress: address) ?? 0
//            let amount = transaction?.estimateAmount(ownerAddress: address) ?? 0
            
            
            let text = "Change: " + String(change) + " BTC"
//            let text = String(change) + " BTC"
            
            cell.setData(amount: text)
            
            return cell
        default:
            fatalError("Can't access section = \(indexPath.section)")
        }
    }
    
}

class TransactionInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func setData(_ input: TransactionInput?) {
        guard let input = input else {
            amountLabel.text = ""
            addressLabel.text = "Unparsed"
            return
        }
        
        amountLabel.text = ""
        addressLabel.text = input.text ?? "-"
    }
    
}

class TransactionAmountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    
    func setData(amount: String?) {
        amountLabel.text = amount
    }
}

class TransactionOutputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBInspectable var address: String? {
        didSet {
            addressLabel?.text = address
        }
    }
    
    func setData(_ output: TransactionOutput?, isMyAddress: Bool = false) {
        
        guard let address = output?.address else {
            amountLabel.text = "-"
            addressLabel.text = "Unparsed"
            return
        }
        
        guard let amount = output?.amount else {
            addressLabel.text = address.body
            amountLabel.text = "-"
            return
        }
        
        addressLabel.text = address.body
        
        switch (address.type) {
        case .Bitcoin:
            amountLabel.text = String(amount) + " BTC"
        case .Ethereum:
            amountLabel.text = String(amount) + " ETH"
        default:
            amountLabel.text = String(amount) + " crypto"
        }
        
    }
    
}

