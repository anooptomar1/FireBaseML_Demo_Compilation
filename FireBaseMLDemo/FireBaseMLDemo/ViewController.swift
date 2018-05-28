//
//  ViewController.swift
//  FireBaseMLDemo
//
//  Created by Admin on 5/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    fileprivate var serviceRequest:[String] = ["Text Recognition" , "Face Detection" , "Barcode Scanning" , "Image Labelling" , "LandMark Recognisation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return serviceRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectionCell
        cell.ServiceLabel.text = serviceRequest[indexPath.row]
        cell.imageHolder.image = UIImage.init(named: serviceRequest[indexPath.row])
        cell.imageHolder.contentMode = .scaleAspectFill
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let faceStoryBoard = UIStoryboard.init(name: "FaceStoryBoard", bundle: nil)
        let labelingStoryBoard = UIStoryboard.init(name: "ImageLabeling", bundle: nil)
        let barcodeStoryBoard = UIStoryboard.init(name: "BarcodeDetection", bundle: nil)
        
        switch indexPath.row
        {
        case 0:
            let Vc = storyBoard.instantiateViewController(withIdentifier: "FBTextDetectionClass") as! FBTextDetectionClass
            self.navigationController?.pushViewController(Vc, animated: true)
        case 1:
            let Vc = faceStoryBoard.instantiateViewController(withIdentifier: "FaceDetectionController") as! FaceDetectionController
            self.navigationController?.pushViewController(Vc, animated: true)
        case 2:
            let Vc = barcodeStoryBoard.instantiateViewController(withIdentifier: "BarcodeDetectionController") as! BarcodeDetectionController
            self.navigationController?.pushViewController(Vc, animated: true)
        case 3:
            let Vc = labelingStoryBoard.instantiateViewController(withIdentifier: "ImageLabelingController") as! ImageLabelingController
            self.navigationController?.pushViewController(Vc, animated: true)
        default:
            return
        }
    }
}
