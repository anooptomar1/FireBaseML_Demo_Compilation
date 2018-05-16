//
//  FaceDetectionController.swift
//  FireBaseMLDemo
//
//  Created by Vishwas on 13/05/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import FirebaseMLVision

class FaceDetectionController: UIViewController
{
    
    @IBOutlet weak var detectFaceButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    lazy var vision = Vision.vision()
    fileprivate var faceDetector:VisionFaceDetector?
    fileprivate var visionImage:VisionImage?
    @IBOutlet weak var imageHolderView: UIImageView!
    @IBOutlet weak var faceDetectionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        configureUI()
    }
    
    func configureUI()
    {
        imageHolderView.layer.borderColor = UIColor.red.cgColor
        imageHolderView.layer.borderWidth = 1
        
        if (imageHolderView.image == nil)
        {
            imageHolderView.isHidden = true
        }
        else
        {
            imageHolderView.isHidden = false
        }
        
        detectFaceButton.layer.cornerRadius = detectFaceButton.frame.height/2
        detectFaceButton.clipsToBounds = true
        
        selectImageButton.layer.cornerRadius = selectImageButton.frame.height/2
        selectImageButton.clipsToBounds = true
    }
    
    @IBAction func imageTapAction(_ sender: UITapGestureRecognizer)
    {
        chooseImage()
    }
    
    @IBAction func selectImageAction(_ sender: UIButton)
    {
        chooseImage()
    }
    
    @IBAction func detectFaceAction(_ sender: UIButton)
    {
        detectFace()
    }
    
    func chooseImage()
    {
        let storyBoardVC = UIStoryboard.init(name: "FaceStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "SelectImageController") as! SelectImageController
        storyBoardVC.delegate = self as ImageSelectionProtocal
        self.present(storyBoardVC, animated: true, completion: nil)
    }
    
    func setFaceDetectorOptions() -> VisionFaceDetectorOptions
    {
        let options = VisionFaceDetectorOptions()
        options.modeType = .accurate
        options.landmarkType = .all
        options.classificationType = .all
        options.minFaceSize = CGFloat(0.1)
        options.isTrackingEnabled = true
        return options
    }
    
    func setFaceDetector(with image:UIImage)
    {
        faceDetector = vision.faceDetector(options: setFaceDetectorOptions())
        let metadata = VisionImageMetadata()
        metadata.orientation = .topRight
        visionImage = VisionImage(image: image)
        visionImage?.metadata = metadata
    }
    
    func detectFace()
    {
        faceDetector?.detect(in: visionImage!) { (faces, error) in
            guard error == nil, let faces = faces, !faces.isEmpty else
            {
                let alert =  UIAlertController.init(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction.init(title: "Ok", style: .default, handler:
                { (_) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.faceDetectionLabel.text = "Total \(faces.count) faces detected"
            print("Total faces = \(faces.count)")
        }
    }
}

extension FaceDetectionController:ImageSelectionProtocal
{
    func SelectedImage(image:UIImage , metadata:Metadata)
    {
        setFaceDetector(with: image)
        imageHolderView.image = image
    }
}

