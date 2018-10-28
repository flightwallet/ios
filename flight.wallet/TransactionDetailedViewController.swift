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
    var transaction: Transaction?
    
    @IBOutlet weak var fromAddressCell: AddressTableViewCell!
    
    @IBOutlet weak var toAddressCell: AddressTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromAddressCell?.addressLabel?.text = "0x17dA6A8B86578CEC4525945A355E8384025fa5Af"
        
        toAddressCell?.addressLabel?.text = "0x408AcEa2C9696f3c238A45b189683B5eDA9b763f"
    }
}
