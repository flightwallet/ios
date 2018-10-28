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
        
    }
}
