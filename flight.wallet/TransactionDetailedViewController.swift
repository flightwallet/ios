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
    var transaction: Transaction? {
        didSet {
            updateLabels()
        }
    }
    
    @IBOutlet weak var fromAddressCell: AddressTableViewCell!
    
    @IBOutlet weak var toAddressCell: AddressTableViewCell!
    
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    
    var isGood: Bool {
        return transaction != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }
    
    func updateLabels () {
        fromAddressLabel?.text = transaction?.from ?? "-"
        
        toAddressLabel?.text = transaction?.to ?? "-"
        
        if let amount = transaction?.amount,
            let change = transaction?.change {
            amountLabel?.text = "\(amount) BTC, (\(change) BTC)"
        } else {
            amountLabel?.text = "- BTC"
        }
        
        
        signatureLabel?.text = isGood
            ? "OK"
            : "Error"
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
        if (action.description == "copy:") {
            var label: UILabel?
            
            switch indexPath.section {
            case 1:
                label = signatureLabel
            case 2:
                label = fromAddressLabel
            case 3:
                label = toAddressLabel
            case 4:
                label = amountLabel
            default:
                label = nil
            }
            
            UIPasteboard.general.string = label?.text ?? transaction?.body
        }
    }
    
}
