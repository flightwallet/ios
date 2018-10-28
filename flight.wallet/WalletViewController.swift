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
    var selectedChain: Chain?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wallet.loaded {
            self.addresses = self.wallet.getAddresses()
            self.tableView.reloadData()
            print(self.addresses)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ScanQRViewController {
            vc.wallet = wallet
            vc.chain = selectedChain
        }
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
        performSegue(withIdentifier: "scanQRSegue", sender: nil)
    }
}

extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
        selectedChain = address.type
    }
}

class AddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chainLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    
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
