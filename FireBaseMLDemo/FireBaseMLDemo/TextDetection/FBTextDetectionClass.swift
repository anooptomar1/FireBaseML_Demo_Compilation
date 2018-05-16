//
//  FBTextDetectionClass.swift
//  FireBaseMLDemo
//
//  Created by Admin on 5/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Firebase

class FBTextDetectionClass: UIViewController
{
    @IBOutlet weak var chooseImageButtom: UIButton!
    @IBOutlet weak var detectedTextLabel: UILabel!
    lazy var vision = Vision.vision()
    var textDetector: VisionTextDetector?
    var currentImage:UIImage = UIImage()
    var imageMeta:Metadata?
    
    @IBOutlet weak var ImageHolderView: UIImageView!
    @IBOutlet weak var buttonDtetctText: UIButton!
    override func viewDidLoad()
    {
        super .viewDidLoad()
        configureTextDetector()
        configureUI()
        ImageHolderView.contentMode = .scaleAspectFit
    }
    
   override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if ImageHolderView.image == nil
        {
            ImageHolderView.isHidden = true
            chooseImageButtom.isHidden = false
        }
        else
        {
            chooseImageButtom.isHidden = true
            ImageHolderView.isHidden = false
        }
        
        detectedTextLabel.text = ""
    }
    
    func configureUI()
    {
        buttonDtetctText.layer.cornerRadius = buttonDtetctText.frame.size.height/2
        buttonDtetctText.clipsToBounds = true
        
        ImageHolderView.layer.borderColor = UIColor.green.cgColor
        ImageHolderView.layer.borderWidth = 1.0
    }
    
    func configureTextDetector()
    {
        textDetector = vision.textDetector()
    }
    
    func detectOrentation(pData:Metadata) -> VisionDetectorImageOrientation
    {
        switch pData.orientation
        {
            
        case .normal:
            return VisionDetectorImageOrientation.topLeft
        case .updown:
            return VisionDetectorImageOrientation.leftBottom
        case .downup:
            return VisionDetectorImageOrientation.rightTop
        case .rotated:
            return VisionDetectorImageOrientation.bottomRight
        }
    }
    
    @IBAction func chooseImageAction(_ sender: UIButton)
    {
        chooseImage()
    }
    
    func setImage(pImage:UIImage? ,meta:Metadata)
    {
        guard let limage = pImage
            else
        {
            return
        }
        
        let image = VisionImage(image: limage)
        let metadata = VisionImageMetadata()
        metadata.orientation =  detectOrentation(pData: meta)
        image.metadata = metadata
        textDetector?.detect(in: image)
        { (features, error) in
            guard error == nil, let features = features, !features.isEmpty else
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
            
            print("Detected text has: \(features.count) blocks")
            for feature in features {
                let value = feature.text
                self.detectedTextLabel.text = value
                print("Value = \(value) /n")
            }
        }
    }
    
    @IBAction func selectImageToRecognise(_ sender: UITapGestureRecognizer)
    {
        chooseImage()
    }
    
    @IBAction func detectTextbuttonAction(_ sender: UIButton)
    {
        setImage(pImage: currentImage , meta:imageMeta!)
    }
    
    func chooseImage()
    {
        let storyBoardVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageSelectViewController") as! ImageSelectViewController
        storyBoardVC.delegate = self as ImageSelectionProtocal
        self.present(storyBoardVC, animated: true, completion: nil)
    }
    
}

extension FBTextDetectionClass:ImageSelectionProtocal
{
    func SelectedImage(image:UIImage , metadata:Metadata)
    {
        currentImage = image
        imageMeta = metadata
        ImageHolderView.image = image
    }
}

