//
//  sessionModel.swift
//  Live_Video
//
//  Created by vishwas ng on 30/09/17.
//  Copyright © 2017 vishwas ng. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class sessionModel: NSObject {
    
    var captureSession:AVCaptureSession
    var outputData:AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    
    init(session:AVCaptureSession)
    {
        self.captureSession = session
    }
    
    
    func addOutPut()
    {
        self.captureSession.beginConfiguration() // 1
        let captureDevice = AVCaptureDevice.default(for: .video)
        let deviceInput = try? AVCaptureDeviceInput.init(device: captureDevice!)
        if (deviceInput == nil)
        {
            
            let alert = UIAlertController.init(title: "This Sucks", message: "because its not real device", preferredStyle: .alert)
            let alerAction = UIAlertAction.init(title: "Ya,I am Dick", style: .cancel, handler: {(UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(alerAction)
        }
        else
        {
            self.captureSession.addInput(deviceInput!)
        }
       
        self.outputData = AVCaptureVideoDataOutput.init()
        self.captureSession.addOutput(self.outputData)
        self.outputData.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String): NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
        self.captureSession.commitConfiguration()
    }
    
    func setPreviewLayer(forRect frame:CGRect)
    {
        self.previewLayer = AVCaptureVideoPreviewLayer.init()
        self.previewLayer.frame = frame
        self.previewLayer.videoGravity = .resizeAspectFill
    }
 
}
