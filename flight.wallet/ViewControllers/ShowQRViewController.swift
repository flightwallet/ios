//
//  ShowQRViewController.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import UIKit

enum QRType {
    case SignedTransaction
    case Address
}

class ShowQRViewController: UIViewController {
    var wallet: Wallet!
    var address: Address!
    
    var data: String?
    var type: QRType!
    
    var qrcodeImage: CIImage!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = data {
            showQR(message: data)
        }
    }
    
    func showQR(message: String) {
        guard let data = message.data(using: String.Encoding.isoLatin1, allowLossyConversion: false) else {
            return
        }
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
            
        qrcodeImage = filter.outputImage
    
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            
        imgQRCode.image = UIImage(ciImage: transformedImage)
    
        qrcodeImage = nil
    }
    
    @IBAction func proceed(_ sender: Any) {
        if type == .SignedTransaction {
            performSegue(withIdentifier: "goHomeSegue", sender: nil)
        } else if type == .Address {
            performSegue(withIdentifier: "scanTransactionSegue", sender: nil)
        }
    }
    
    @IBAction func copyRawSignedTx(_ sender: Any) {
        UIPasteboard.general.string = data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ScanQRViewController {
            vc.wallet = wallet
            vc.address = address
        }
    }
}
