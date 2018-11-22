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
                vc.address = selectedAddress
                vc.wallet = wallet
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
        
        if address.type == .Ethereum {
            selectedAddress = nil
            tableView.deselectRow(at: indexPath, animated: true)
            showAlert(title: "Ethereum is Disabled", message: "Sorry, Ethereum wallet does not work yet")
        } else if address.isMainnet {
            selectedAddress = nil
            tableView.deselectRow(at: indexPath, animated: true)
            showAlert(title: "Mainnet is Disabled", message: "Sorry, Mainnet addresses do not work yet")
        } else {
            selectedAddress = address
        }
        
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action:
        Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if (action.description == "copy:") {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if (action.description == "copy:") {
            let address = addresses[indexPath.row]
            print(address.body!)
            UIPasteboard.general.string = address.body
        }
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
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
