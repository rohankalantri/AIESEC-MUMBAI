//
//  NewsAdditionViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 15/02/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import Firebase
import Photos

class NewsAdditionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    var newsArticle: NewsDetails.NewsDetailsStruct!
    
    @IBOutlet weak var articleDetails: UITextView!
    @IBOutlet weak var articleTitle: UITextField!

    @IBOutlet weak var imagePickerView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.newsArticle = NewsDetails.NewsDetailsStruct()
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        self.imagePickerView.isUserInteractionEnabled = true
        self.imagePickerView.addGestureRecognizer(singleTap)
    }
    
    @objc func tapDetected() {
        print("Imageview Clicked")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if authPhotos() {
        
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            imagePickerView.contentMode = .scaleToFill
            imagePickerView.image = chosenImage

            let imageUrl          = info[UIImagePickerControllerImageURL] as? NSURL
            let imageName         = imageUrl?.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let photoURL          = NSURL(fileURLWithPath: documentDirectory)
            let localPath         = photoURL.appendingPathComponent(imageName!)

            dismiss(animated: true, completion: nil)
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let databaseRef = Database.database().reference()
            
            let date = Date()
            let timeStamp = date.timeIntervalSince1970
            
            self.newsArticle.articleKey = String(format: "%.0f", timeStamp)

            var data = NSData()
            data = UIImageJPEGRepresentation(chosenImage, 0.8)! as NSData
            
            let imgString = data.base64EncodedString(options: .lineLength64Characters)
            print(imgString)
            self.newsArticle.imageURL = imgString
            
            // set upload path
            
//            if let newsKey = self.newsArticle?.getKey() {
//                let filePath = "news/\(self.newsArticle.articleKey)/\(localPath!)"
//                let metaData = StorageMetadata()
//                metaData.contentType = "image/jpg"
//                storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        return
//                    }else{
//                        //store downloadURL
//                        let downloadURL = metaData!.downloadURL()!.absoluteString
//                        self.newsArticle.imageURL = downloadURL
//
//                        //store downloadURL at database
//
//                    }
//                }
//            }

            
            
//            if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage, let photoData = UIImageJPEGRepresentation(photo, 0.8) {
//
//                uploadPhoto(photoData: photoData)
//
//            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        if validateFields() {
            
            self.newsArticle.title = articleTitle.text!
            self.newsArticle.details = articleDetails.text!
            
            let ref = Database.database().reference()
            
//            if let newsKey = self.newsArticle.articleKey {
                ref.child("news/\(self.newsArticle.articleKey)").updateChildValues(["Title": self.newsArticle.title])

                ref.child("news/\(self.newsArticle.articleKey)").updateChildValues(["Details": self.newsArticle.details])
                
                ref.child("news/\(self.newsArticle.articleKey)").updateChildValues(["newsPhoto": self.newsArticle.imageURL])
                
                //ref.child("news/\(newsKey)").updateChildValues(["newsPhoto": self.newsArticle?.imageURL])
                
                print("Article Registered!")
                
                //self.performSegue(withIdentifier: "doneSegue", sender: self)
                
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
//            }

        } else {
            
            let alert = UIAlertController(title: "Error", message: "One or more mandatory fields not filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func validateFields () -> Bool{
        
        if (articleTitle.text != "" && articleDetails.text != "" && self.newsArticle?.imageURL != ""){
            return true
        } else {
            return false
        }
        
    }
    
    func authPhotos () -> Bool {
        
        var status = PHPhotoLibrary.authorizationStatus()
        var tempStatus = false
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            tempStatus = true
            print("Access granted")
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
                    tempStatus = true
                }
                    
                else {
                    print("Please Authorize!")
                }
            })

        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    tempStatus = true
                }
                    
                else {
                    print ("Grant access")
                }
            })

        }
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
            print("Restricted Access")
        }
        
                    return tempStatus
    }
    
    
    func uploadPhoto (photoData: Data) {
//
//        let date = Date()
//        let timeStamp = date.timeIntervalSince1970
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let databaseRef = Database.database().reference()
//
//        self.newsArticle?.setKey(Key: String(format: "%.0f", timeStamp))
//
//        let imagePath = "news/" + "\(String(format: "%.0f", timeStamp))/newsPhoto.jpg"
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        storageRef.child(imagePath).putData(photoData, metadata: metadata) { (metadata, error) in
//
//            if let error = error {
//                print("error uploading: \(error)")
//                return
//            }
//
//            databaseRef.child("news/\(String(format: "%.0f", timeStamp))").updateChildValues(["newsPhoto": storageRef.child((metadata?.path)!).description])
//            print("image added!")
//        }
//
    }

    
}
