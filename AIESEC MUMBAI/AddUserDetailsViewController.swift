//
//  AddUserDetailsViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 17/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import Eureka
import Firebase

class AddUserDetailsViewController: FormViewController {

    var firstname: String = ""
    var lastname: String = ""
    var userDictionary = [String: String]()
    var body: String = ""
    var keyOfSelection: String = ""
    var department: String = ""
    var phone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initializeForm()
        getUsers()
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
                
                }.onChange({ (row) in

                    self.firstname = row.value != nil ? row.value! : ""
                })
        
            <<< TextRow() { row in // 3
                row.title = "Last Name"
                row.tag = "Lastname"//4
                row.placeholder = "Doe"
                row.add(rule: RuleRequired())
                
                }.onChange({ (row) in
                    
                    self.lastname = row.value != nil ? row.value! : ""
                })
            
            +++ Section("Contact")
            <<< PhoneRow(){ (row) in
                row.title = "Phone"
                row.add(rule: RuleRequired())
                
                } .onChange ({ (row) in
                    if let phoneEntered = row.value {
                        self.phone = phoneEntered
                    }
                })
        
            +++ Section("Department & Portfolio")
            <<< ActionSheetRow<String>() {
                $0.title = "I am a"
                $0.tag = "Body"
                $0.selectorTitle = "I am a/an"
                $0.options = ["EB","MB","GB"]
                $0.add(rule: RuleRequired())
                
                } .onChange() { (row) in
                   
                    if let selectedBody = row.value {
                        self.body = selectedBody
                    }
            }
        
            
            <<< ActionSheetRow<String>() {
                $0.title = "Department"
                $0.tag = "Departmnent"
                $0.selectorTitle = "Department"
                $0.options = ["iGV", "iGET", "oGV (Sidelle)","oGET", "oGX (Muskan)", "BD", "Finance", "TM"]
                $0.add(rule: RuleRequired())
                
                } .onChange() {(row) in
                    
                    if let selectedDepartment = row.value {
                        self.department = selectedDepartment
                    }
                }
        
            <<< PushRow<String>() { row in
            
                row.title = "Immediate leader: "
                row.tag = "immediateLeader"
                
                var usersArray = [String]()
                for (_,value) in userDictionary {
                    usersArray.append(value)
                }
                row.options = usersArray
                } .onChange() { (row) in
                    if let selectedValue = row.value {
                        
                        for (key,value) in self.userDictionary {
                            if value == selectedValue {
                                self.keyOfSelection = key
                            }
                        }
                        
                    }
        }
        
    }
    
    func getUsers() {
        var counter = 1
        let ref = Database.database().reference()
        ref.child("users").observe(.value) { (snapshot) in
            
            if snapshot.exists() {
                let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                for object in snapshots {
                    let usersObject = object.value as! [String:AnyObject]
                
                    if usersObject["body"] as! String == "EB" || usersObject["body"] as! String == "MB" {
                        let key = object.key
                        let firstname = usersObject["firstname"] as! String
                        let lastname = usersObject["lastname"] as! String
                        self.userDictionary[key] = firstname + " " + lastname
                    }
                }
            }
            if counter == 1 {
                self.initializeForm()
                counter = counter + 1
            }
            
        }
        
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        saveDetails()
        
        
    }
    
    func saveDetails() {
        
        if validateFields() {
           
            let ref = Database.database().reference()
            if let uID = Auth.auth().currentUser?.uid {
               
                ref.child("users/\(uID)").updateChildValues(["firstname": self.firstname])
                ref.child("users/\(uID)").updateChildValues(["lastname": self.lastname])
                ref.child("users/\(uID)").updateChildValues(["body": self.body])
                ref.child("users/\(uID)").updateChildValues(["department": self.department])
                ref.child("users/\(uID)").updateChildValues(["phone": self.phone])
                ref.child("users/\(uID)").updateChildValues(["immediateLeader": self.keyOfSelection])
                
                ref.child("users/\(self.keyOfSelection)/team").updateChildValues(["\(uID)": (self.firstname + " " + self.lastname)])
            }
            
            
            self.performSegue(withIdentifier: "mainPageSegue", sender: self)
            
//
//            let alert = UIAlertController(title: "", message: "Data Saved", preferredStyle: .alert)
//            self.present(alert, animated: true, completion: nil)
//
//            // change to desired number of seconds (in this case 5 seconds)
//            let when = DispatchTime.now() + 1
//            DispatchQueue.main.asyncAfter(deadline: when){
//                // your code with delay
//                alert.dismiss(animated: true, completion: nil)
//
//            }
//
            
        }
        
    }
    
    func validateFields() -> Bool{
        
        if (self.body == "" || self.firstname == "" || self.lastname == "" || self.keyOfSelection == "" || self.department == "" || self.phone.count != 10) {
            let alert = UIAlertController(title: "Error", message: "Invalid information in one or more fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The dismiss alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
        
    }
}
