//
//  ImageLabelingController.swift
//  FireBaseMLDemo
//
//  Created by Vishwas on 16/05/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import FirebaseMLVision

class ImageLabelingController: UIViewController {

    @IBOutlet weak var imageSelectionButton: UIButton!
    @IBOutlet weak var imageHolderView: UIImageView!
    @IBOutlet weak var detectImageButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    var options:VisionLabelDetectorOptions?
    var visionImage:VisionImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabelConfidence()
        
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
        
        imageSelectionButton.layer.cornerRadius = imageSelectionButton.frame.height/2
        imageSelectionButton.clipsToBounds = true
        
        detectImageButton.layer.cornerRadius = detectImageButton.frame.height/2
        detectImageButton.clipsToBounds = true
    }
    
    func setLabelConfidence()
    {
         options = VisionLabelDetectorOptions(
            confidenceThreshold: 0.5
        )
    }
    
    func setVisionImage(pImage:UIImage)
    {
        let metadata = VisionImageMetadata()
        metadata.orientation = .rightTop
        visionImage = VisionImage(image: pImage)
        visionImage?.metadata = metadata
    }
    
    func getImageLabels()
    {
        let vision = Vision.vision()
        let labelDetector = vision.labelDetector(options: options!)
        labelDetector.detect(in: visionImage!) { (labels, error) in
            guard error == nil, let labels = labels, !labels.isEmpty else
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
            
            var labelArray:[String] = [String]()
            for label in labels {
                let labelText = label.label
                let entityId = label.entityID
                let confidence = label.confidence
                labelArray.append("\(labelText) with conficence of \(confidence)\n")
                print(entityId)
            }
            self.resultLabel.text = labelArray.joined()
        }
    }
    
    @IBAction func selectImageAction(_ sender: UIButton)
    {
        chooseImage()
    }
    
    @IBAction func detectImageLabel(_ sender: UIButton)
    {
        getImageLabels()
    }
    
    @IBAction func imageSelectionAction(_ sender: Any)
    {
        chooseImage()
    }
    
    func chooseImage()
    {
        let storyBoardVC = UIStoryboard.init(name: "ImageLabeling", bundle: nil).instantiateViewController(withIdentifier: "LabelingImageSelectController") as! LabelingImageSelectController
        storyBoardVC.delegate = self as ImageSelectionProtocal
        self.present(storyBoardVC, animated: true, completion: nil)
    }
}

extension ImageLabelingController:ImageSelectionProtocal
{
    func SelectedImage(image:UIImage , metadata:Metadata)
    {
        setVisionImage(pImage: image)
        imageHolderView.image = image
    }
}
