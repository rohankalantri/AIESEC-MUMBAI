//
//  ProfileViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 26/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import Eureka
import Firebase

struct userInfo {
    var firstname: String = ""
    var lastname: String = ""
    var phone: String = ""
}

class ProfileViewController: FormViewController {

    var user = userInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }


    func initializeForm() {
        form
            +++ Section("Basic Info")    //2
            <<< TextRow() { row in // 3
                row.title = "First Name"
                row.tag = "Firstname"//4
                row.placeholder = "John"
                row.add(rule: RuleRequired())
                row.value = self.user.firstname
                
                }.onChange({ (row) in
                    
                    if let firstname = row.value {
                        self.user.firstname = firstname
                    }
                })
            
            <<< TextRow() { row in // 3
                row.title = "Last Name"
                row.tag = "Lastname"//4
                row.placeholder = "Doe"
                row.add(rule: RuleRequired())
                row.value = self.user.lastname
                
                }.onChange({ (row) in
                    
                    if let lastname = row.value {
                        self.user.lastname = lastname
                    }
                })
            
            +++ Section("Contact")
            <<< PhoneRow(){ (row) in
                row.title = "Phone"
                row.add(rule: RuleRequired())
                row.value = self.user.phone
                } .onChange ({ (row) in
                    if let phoneEntered = row.value {
                        self.user.phone = phoneEntered
                    }
                })
        
    }
    
    func getData() {
        
        let ref = Database.database().reference()
        
        
        // MARK: Getting user details from Firebase
        
        if let uID = Auth.auth().currentUser?.uid {
            
            ref.child("users/\(uID)").observe(.value) { (snapshot) in
                
                if snapshot.exists() {
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    for object in snapshots {
                        //                        let userObject = object.value as! [String:AnyObject]
                        
                        if object.key == "firstname" {
                            self.user.firstname = object.value as! String
                        } else if object.key == "lastname" {
                            self.user.lastname = object.value as! String
                        } else if object.key == "phone" {
                            self.user.phone = object.value as! String
                        }
                        
                    }
                    self.initializeForm()
                }
            }
        }
        
        
    }
    
    
    @IBAction func saveDetails(_ sender: Any) {
        
        let ref = Database.database().reference()
        if let uID = Auth.auth().currentUser?.uid {
            
            ref.child("users/\(uID)").updateChildValues(["firstname": self.user.firstname])
            ref.child("users/\(uID)").updateChildValues(["lastname": self.user.lastname])
            ref.child("users/\(uID)").updateChildValues(["phone": self.user.phone])

        }
        let alert = UIAlertController(title: "", message: "Details Updated", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }

    }
    
}
