//
//  NewsDetails.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 18/02/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import Foundation
import UIKit

class NewsDetails: NSObject {
    
    struct NewsDetailsStruct {
        var articleKey: String = ""
        var title: String = ""
        var details: String = ""
        var imageURL: String = ""
        var image: UIImage!
    }
    
    var newsArticle = NewsDetailsStruct()
    
//    var articleKey: String = ""
//    var title: String?
//    var details: String?
//    var image: UIImage?
//    var imageURL: String!
//
//    func setKey(Key: String) {
//        self.articleKey = Key
//    }
//
//    func getKey() -> String {
//        return self.articleKey
//    }
//
//    func setTitle (Title: String) {
//        self.title = Title
//    }
//
//    func setIMGURL (URL: String) {
//        self.imageURL = URL
//    }
//
//    func setDetails (Details: String) {
//        self.details = Details
//    }
//
//    func getTitle() -> String {
//        return self.title!
//    }
//
//    func getDetails() -> String {
//        return self.details!
//    }
//
//    func getURL() -> String {
//        return self.imageURL!
//    }
}

