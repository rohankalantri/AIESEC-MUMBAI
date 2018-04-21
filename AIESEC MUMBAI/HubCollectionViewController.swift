//
//  HubCollectionViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 21/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftOverlays

private let reuseIdentifier = "Cell"

class HubCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var addNews: UIBarButtonItem!
    
    var news = [NewsDetails.NewsDetailsStruct]()
    
    override func viewWillAppear(_ animated: Bool) {
        validateEB()
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return self.news.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsArticleCell", for: indexPath) as! HubCollectionViewCell
        
        let newsArticle = self.news[indexPath.row]
        
        
        cell.titleLabel?.textAlignment = .center
        cell.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.titleLabel?.layer.masksToBounds = true
        cell.titleLabel?.layer.cornerRadius = 7
        cell.titleLabel?.text = newsArticle.title
        
        cell.newsImage.image = newsArticle.image
        cell.timeLabel.font = UIFont(name: cell.timeLabel.font.fontName, size: 10)
        cell.timeLabel.text = getTime(timeStamp: newsArticle.articleKey)
        
        Alamofire.request(self.makeServerUrl(url: newsArticle.imageURL)).validate().responseData(completionHandler: {
            response in
            
            let data = response.data
            
            var relativePath = newsArticle.imageURL.replacingOccurrences(of: "/", with: "")
            if let dotRange = relativePath.range(of: ".jpeg") {
                relativePath.removeSubrange(dotRange.upperBound..<relativePath.endIndex)
//                print(relativePath)
            }
            let path = self.documentsPathForFileName(name: relativePath)
            
            switch response.result {
                
            case .success :
                
                
                let imageData = data
                
                do {
                    
                    try imageData?.write(to: path)
                    
                } catch let error as Error {
                    print(error.localizedDescription)
                }
                //                        LoadingDialog.hideActivityIndicator(view: imageView)
                //                    return UIImage(data: data!)
                if let optionalImage = UIImage(data: data!) {
                    cell.newsImage.image = optionalImage
                    print("image taken from fresh data")
                }
                
            case .failure :
                
                let oldImageData = try! Data(contentsOf: path)
                
                if let oldImage = UIImage(data: oldImageData) {
                    print("image taken from old data")
                    cell.newsImage.image = oldImage
                }
            }
        })
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let articleDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "articleDetailsVC") as! ArticleDetailsViewController
        
        articleDetailsVC.titleText = self.news[indexPath.row].title
        articleDetailsVC.details = self.news[indexPath.row].details
        articleDetailsVC.image = self.news[indexPath.row].image
        articleDetailsVC.imageURL = self.news[indexPath.row].imageURL
        
        self.navigationController?.pushViewController(articleDetailsVC, animated: true)
        
        
    }
    
    private func documentsPathForFileName(name: String) -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as String
        let fullPath = URL.init(fileURLWithPath: path).appendingPathComponent(name)
        return fullPath
    }
    
    func makeServerUrl(url: String) -> String {
        
        return url
    }
    
    func loadData() {
        
        self.news.removeAll()
        
        self.showWaitOverlay()
        let ref = Database.database().reference()
        ref.child("news").observe(.value) { (snapshot) in
//        SingleEvent(of: .value, with: { (snapshot) in

            if snapshot.exists() {
                let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                for object in snapshots {
                    var newsObject = object.value as! [String:AnyObject]
                    var newsDictionary = NewsDetails.NewsDetailsStruct()
                    
                    
                    if let title = newsObject["Title"] as? String, let details = newsObject["Details"] as? String {
                        
                        newsDictionary.title = title
                        
                        newsDictionary.details = details
                    }

                    newsDictionary.imageURL = (newsObject["newsPhoto"] as! String)
                    print(newsDictionary.imageURL)
                    NSLog(newsDictionary.imageURL)
//                    newsDictionary.image = self.downloadImage(URLString: newsDictionary.imageURL)
//                    DispatchQueue.main.async {
//                        Alamofire.request(self.makeServerUrl(url: newsDictionary.imageURL)).validate().responseData(completionHandler: {
//                            response in
//
//                            let data = response.data
//
//                            var relativePath = newsDictionary.imageURL.replacingOccurrences(of: "/", with: "")
//                            if let dotRange = relativePath.range(of: ".jpeg") {
//                                relativePath.removeSubrange(dotRange.upperBound..<relativePath.endIndex)
//                                print(relativePath)
//                            }
//                            let path = self.documentsPathForFileName(name: relativePath)
//
//                            switch response.result {
//
//                            case .success :
//
//
//                                let imageData = data
//
//                                do {
//
//                                    try imageData?.write(to: path)
//
//                                } catch let error as Error {
//                                    print(error.localizedDescription)
//                                }
//                                //                        LoadingDialog.hideActivityIndicator(view: imageView)
//                                //                    return UIImage(data: data!)
//                                if let optionalImage = UIImage(data: data!) {
//                                    newsDictionary.image = optionalImage
//                                }
//
//                            case .failure :
//
//                                let oldImageData = try! Data(contentsOf: path)
//                                if let oldImage = UIImage(data: oldImageData) {
//                                    newsDictionary.image = oldImage
//                                }
//                            }
//                        })
//                    }
                    
                    
                    newsDictionary.articleKey = object.key
                    
                    self.news.append(newsDictionary)
                    
                    
                }
            }
            self.collectionView?.reloadData()
            self.removeAllOverlays()
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func getTime(timeStamp: String) -> String {
        
        if let tempTimeStamp = Double(timeStamp) {
            let date = Date(timeIntervalSince1970: tempTimeStamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: String(describing: TimeZone.current)) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
        
        return "nil"
    }
    
    func validateEB() {
        
        let ref = Database.database().reference()
        if let ID = Auth.auth().currentUser?.uid {
            print(ID)
            ref.child("users/\(ID)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    
                    for object in snapshots {
                        
                        if object.key == "body" {
                            if object.value as! String == "EB" {

                            } else {
                                self.navigationItem.rightBarButtonItems = []
                            }
                        }
                    }
                }
            })
        }
        
    }
    
    
    
    
    
//    func downloadImage(URLString: String) -> UIImage {
//
//        var image: UIImage!
//
////        if let imgURL = URL(string: URLString) {
//
//            //                LoadingDialog.showActivityIndicator(view: imageView, withOpaqueOverlay: false)
//            Alamofire.request(makeServerUrl(url: URLString)).validate().responseData(completionHandler: {
//                response in
//
//                let data = response.data
//
//                let relativePath = URLString.replacingOccurrences(of: "/", with: "")
//
//                let path = self.documentsPathForFileName(name: relativePath)
//
//                switch response.result {
//
//                case .success :
//
//
//                    let imageData = data
//
//                    do {
//
//                        try imageData?.write(to: path)
//
//                    } catch let error as Error {
//                        print(error.localizedDescription)
//                    }
//                    //                        LoadingDialog.hideActivityIndicator(view: imageView)
////                    return UIImage(data: data!)
//                    if let optionalImage = UIImage(data: data!) {
//                        image = optionalImage
//                    }
//
//                case .failure :
//
//                    let oldImageData = try! Data(contentsOf: path)
//                    if let oldImage = UIImage(data: oldImageData) {
//                        image = oldImage
//                    }
//
//                    //                        LoadingDialog.hideActivityIndicator(view: imageView)
////                    image = oldImage!
//
//                }
//            })
//            return image
////        } else {
////            return UIImage(named: "LCPIC")!
////        }
//
//    }
    
            

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

 
}
