//
//  SecondViewController.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 27/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    var qrCodePreview: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var parsedTx: String?
    var foundTransaction: Bool = false
    var wallet: Wallet!
    var address: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPreview()
        initQRReader()
    }
    
    func initPreview() {
        do {
            let type = AVCaptureDevice.DeviceType(rawValue: "front_camera")
            let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [type], mediaType: .video, position: .front)
            
            let frontCamera = deviceDiscovery.devices.first { device in device.position == .front }
            
            guard let captureDevice = frontCamera else {
                return
            }
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            let captureSession = AVCaptureSession()
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            
            
            previewView.layer.addSublayer(videoPreviewLayer)
            
            
            captureSession.startRunning()
        
            
        } catch {
            print(error)
        }
    }
    
    func initQRReader() {

        // Initialize QR Code Frame to highlight the QR code
        qrCodePreview = UIView()
        
        if let qrCodePreview = qrCodePreview {
            qrCodePreview.layer.borderColor = UIColor.green.cgColor
            qrCodePreview.layer.borderWidth = 2
            view.addSubview(qrCodePreview)
            view.bringSubviewToFront(qrCodePreview)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if foundTransaction {
            return
        }
        
        if metadataObjects.count == 0 {
            qrCodePreview?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            if let message = metadataObj.stringValue {
                print(message)
                messageLabel.text = message
                
                foundTransaction = true
                transactionScanned(encodedTx: message)
            }
        }
    }
    
    func transactionScanned(encodedTx: String) {
        if parsedTx != nil {
            return
        } else {
            parsedTx = encodedTx
        }
        
        performSegue(withIdentifier: "transactionScannedSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let txController = segue.destination as? TransactionReceiptViewController {
            txController.parsedTx = parsedTx
            txController.wallet = wallet
            txController.chain = address?.type
            
            self.parsedTx = nil
        }
    }
}

