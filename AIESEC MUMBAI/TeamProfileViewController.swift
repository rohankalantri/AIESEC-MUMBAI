//
//  TeamProfileViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 26/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import Eureka
import Firebase

struct userStruct {
    var firstname: String = ""
    var lastname: String = ""
    var phone: String = ""
    var immediateLeader: String = ""
    var body: String = ""
    var department: String = ""
    var uID: String = ""
    var team = [String: String]()
    
}

class TeamProfileViewController: FormViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    var editable: String = "false"
    var user = userStruct()
    var userDictionary = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
//        initializeForm()
        // Do any additional setup after loading the view.
    }
    
    func initializeForm() {
        
        form
            
            +++ Section("Department & Body")
            <<< ActionSheetRow<String>() {
                $0.title = "I am a"
                $0.tag = "Body"
                $0.selectorTitle = "I am a/an"
                $0.options = ["EB","MB","GB"]
                $0.add(rule: RuleRequired())
                $0.value = self.user.body
                
                } .onChange() { (row) in
                    
                    if let selectedBody = row.value {
                        self.user.body = selectedBody
                    }
            }
            
            
            <<< ActionSheetRow<String>() {
                $0.title = "Department"
                $0.tag = "Departmnent"
                $0.selectorTitle = "Department"
                $0.options = ["iGV", "iGET", "oGV (Sidelle)","oGET", "oGX (Muskan)", "BD", "Finance", "TM"]
                $0.add(rule: RuleRequired())
                $0.value = self.user.department
                
                } .onChange() {(row) in
                    
                    if let selectedDepartment = row.value {
                        self.user.department = selectedDepartment
                    }
            }
            
            <<< PushRow<String>() { row in
                
                row.title = "Immediate leader: "
                row.tag = "immediateLeader"
                
                row.value = self.userDictionary[self.user.immediateLeader]
                var usersArray = [String]()
                for (_,value) in self.userDictionary {
                    usersArray.append(value)
                }
                row.options = usersArray
                } .onChange() { (row) in
                    if let selectedValue = row.value {
                        
                        for (key,value) in self.userDictionary {
                            if value == selectedValue {
                                self.user.immediateLeader = key
                            }
                        }
                        
                    }
                }

        
            +++ Section("Team")
            <<< MultipleSelectorRow<String>() { row in
                
                row.title = "Team: "
                
                var teamArray = [String]()
                for (_,value) in self.user.team {
                    teamArray.append(value)
                    row.value?.insert(value)
                }
                row.options = teamArray
                
                } .onChange() { (row) in
                    if let selectedValue = row.value {
                        
                        let tempTeam = self.user.team
                        self.user.team.removeAll()
                        
                        for users in selectedValue {
                            
                            for (key,value) in tempTeam {
                                if value == users {
                                    self.user.team[key] = value
                                }
//                                self.user.team.append(users)
                            }
                        }
                    }
                }
        
        
    }
    
    func getData() {
        self.userDictionary.removeAll()
        let ref = Database.database().reference()

        
        // MARK: Getting user details from Firebase
        
        if let uID = Auth.auth().currentUser?.uid {
            
            ref.child("users/\(uID)").observe(.value) { (snapshot) in
                
                if snapshot.exists() {
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    for object in snapshots {
//                        let userObject = object.value as! [String:AnyObject]
                        
                        if object.key == "body" {
                            self.user.body = object.value as! String
                        } else if object.key == "department" {
                            self.user.department = object.value as! String
                        } else if object.key == "immediateLeader" {
                            self.user.immediateLeader = object.value as! String
                        } else if object.key == "team" {
                            let teamObject = object.value as! [String: AnyObject]
                            
                            for (key,value) in teamObject {
                                self.user.team[key] = value as? String
                            }
                        }
//
//                        self.user.body = userObject["body"] as! String
//                        self.user.department = userObject["department"] as! String
//                        self.user.immediateLeader = userObject["immediateLeader"] as! String
//
//
                    }
                }
                
            }
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
                        

//
//                        if object.key == "isEditable" {
//                            self.editable = object.value as! String
//                            if self.editable == "false" {
//                                self.saveButton.isEnabled = false
//                            }
//                        }
                    }
                    
                }
                self.initializeForm()
            }
        }


        
    }

    @IBAction func saveDetails(_ sender: Any) {
        
        let ref = Database.database().reference()
        if let uID = Auth.auth().currentUser?.uid {

            ref.child("users/\(uID)").updateChildValues(["body": self.user.body])
            ref.child("users/\(uID)").updateChildValues(["department": self.user.department])
            ref.child("users/\(uID)").updateChildValues(["immediateLeader": self.user.immediateLeader])
            
            ref.child("users/\(self.user.immediateLeader)/team").updateChildValues(["\(uID)": (self.user.firstname + " " + self.user.lastname)])
            
            ref.child("users/\(uID)/team").updateChildValues(self.user.team)
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
