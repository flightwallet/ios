//
//  ShowQRViewController.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation
import UIKit

class ShowQRViewController: UIViewController {
    var data: String?
    
    var qrcodeImage: CIImage!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    
    override func viewDidLoad() {
        if let data = data {
            showQR(message: data)
        }
    }
    
    func showQR(message: String) {
        guard let data = message.data(using: String.Encoding.isoLatin1, allowLossyConversion: false) else {
            return
        }
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter.outputImage
            
            imgQRCode.image = UIImage(ciImage: qrcodeImage)
        }
    }
}
