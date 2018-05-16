//
//  ImageSelectViewController.swift
//  FireBaseMLDemo
//
//  Created by Admin on 5/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol ImageSelectionProtocal
{
    func SelectedImage(image:UIImage , metadata:Metadata)
}

enum Orientation:Int
{
    case normal = 0
    case updown = 1
    case downup = 2
    case rotated = 3
}

struct Metadata
{
    var name:String
    var orientation:Orientation
}

class ImageSelectViewController: UIViewController {

    fileprivate var imageServiceRequest:[String] = ["TextImage" , "TextImage_TopBottom" , "TextImage_BottomTop","TextImage_upsidedown"]
    var delegate:ImageSelectionProtocal?
    
    
    @IBOutlet weak var imageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ImageSelectViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return imageServiceRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ImageSelectionCell
        cell.imageViewHolder.image = UIImage.init(named: imageServiceRequest[indexPath.row])
        cell.imageViewHolder.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let meta = Metadata.init(name: imageServiceRequest[indexPath.row], orientation: Orientation(rawValue: indexPath.row)!)
        
        self.delegate?.SelectedImage(image: UIImage.init(named: imageServiceRequest[indexPath.row])!,metadata: meta)
        self.dismiss(animated: true, completion: nil)
    }
}

