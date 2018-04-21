//
//  ArticleDetailsViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 27/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController {

    var image: UIImage!
    var titleText: String = ""
    var details: String = ""
    var imageURL: String = ""
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.image
        self.titleLabel.text = self.titleText
        self.detailsLabel.text = self.details
        
//        let relativePath = imageURL.replacingOccurrences(of: "/", with: "")
//        let path = self.documentsPathForFileName(name: relativePath)
//        
//        let oldImageData = try! Data(contentsOf: path)
//        let oldImage = UIImage(data: oldImageData)
//        
//        self.imageView.image = oldImage
        // Do any additional setup after loading the view.
    }
    
    private func documentsPathForFileName(name: String) -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as String
        let fullPath = URL.init(fileURLWithPath: path).appendingPathComponent(name)
        return fullPath
    }
    


}
