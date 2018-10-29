//
//  FirstViewController.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 27/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    let wallet = Wallet.instance
    var addresses: [Address] = []
    var selectedAddress: Address? {
        didSet {
            if selectedAddress == nil {
                // SELECT
                payButton.setTitle("SELECT ACCOUNT", for: .normal)
            } else {
                // PAY
                payButton.setTitle("PAY", for: .normal)
            }
        }
    }
    
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addresses = self.wallet.getAddresses()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ScanQRViewController {
            vc.wallet = wallet
            vc.address = selectedAddress
        }
        
        if let vc = segue.destination as? ShowQRViewController {
            if segue.identifier == "showAddressSegue" {
                vc.data = selectedAddress?.body
            } else {
                
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return selectedAddress != nil
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
        performSegue(withIdentifier: "scanQRSegue", sender: nil)
    }
}

extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let address = addresses[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as? AddressTableViewCell else {
            fatalError("Can't dequeue cell")
        }
        
        cell.setData(address)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        selectedAddress = address
    }
}

class AddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chainLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    
    @IBInspectable var address: String? {
        didSet {
            addressLabel?.text = address
        }
    }
    
    func setData(_ address: Address) {
        switch (address.type) {
        case .Bitcoin:
            chainLabel.text = "Bitcoin"
        case .Ethereum:
            chainLabel.text = "Ethereum"
        default:
            chainLabel.text = "Crypto"
        }
        
        addressLabel.text = address.body
        
        accountNameLabel.text = address.friendlyName
    }
    
}
