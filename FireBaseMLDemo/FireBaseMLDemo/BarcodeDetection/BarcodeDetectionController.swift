//
//  BarcodeDetectionController.swift
//  FireBaseMLDemo
//
//  Created by Vishwas on 22/05/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase


class BarcodeDetectionController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    var session:sessionModel?
    lazy var vision = Vision.vision()
    var barcodeDetector :VisionBarcodeDetector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        session = sessionModel.init(session: captureSession)
        session?.setPreviewLayer(forRect: previewView.bounds)
        session?.addOutPut()
        session?.captureSession.startRunning()
        session?.outputData.setSampleBufferDelegate(self , queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session?.previewLayer.bounds = previewView.layer.frame
        previewView.layer.addSublayer((session?.previewLayer)!)
        
        self.barcodeDetector = vision.barcodeDetector()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BarcodeDetectionController:AVCaptureVideoDataOutputSampleBufferDelegate
{
     func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if let barcodeDetector = self.barcodeDetector {
            
            let visionImage = VisionImage(buffer: sampleBuffer)
            
            barcodeDetector.detect(in: visionImage) { (barcodes, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                for barcode in barcodes! {
                    print(barcode.rawValue!)
                    self.resultLabel.text = barcode.rawValue!
                }
            }
        }
    }
}




