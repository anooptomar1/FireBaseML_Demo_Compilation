//
//  ImageLabelingController.swift
//  FireBaseMLDemo
//
//  Created by Vishwas on 16/05/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ImageLabelingController: UIViewController {

    @IBOutlet weak var imageSelectionButton: UIButton!
    @IBOutlet weak var imageHolderView: UIImageView!
    @IBOutlet weak var detectImageButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

   
    
    @IBAction func selectImageAction(_ sender: UIButton)
    {
        chooseImage()
    }
    
    @IBAction func detectImageLabel(_ sender: UIButton)
    {
        
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
        //setFaceDetector(with: image)
        imageHolderView.image = image
    }
}
