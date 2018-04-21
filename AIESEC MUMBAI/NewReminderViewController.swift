//
//  NewReminderViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 08/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import EventKit
import Eureka
import Firebase
import FirebaseAuthUI

class NewReminderViewController: FormViewController {

    var eventStore: EKEventStore!
    var datePicker: UIDatePicker!
    
    var userBody: String = "GB"
    var reminderTitle: String = ""
    var reminderDate: Date!
    var timeStamp: String = ""
    var tempTimeStamp: Double = 12345678
    var reminderDetails: String = ""
    
    var teamDictionary = [String: String]()
    var assignedTo = [String]()
    var assignedKeys = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getTeam()
//        initializeForm()
        getBody()
    }

    func addDate(){
        // Assign the date picker date to the text field
        //self.dateTextField.text = self.datePicker.date.description
        
    }
    
    func getBody() {
        
        let ref = Database.database().reference()
        if let ID = Auth.auth().currentUser?.uid {
            print(ID)
            ref.child("users/\(ID)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    
                    for object in snapshots {
                        
                        if object.key == "body" {
                            self.userBody = object.value as! String
                            print ("body is: \(self.userBody)")
                        }
                    }
                }
            })
        }
        
    }
    
    @IBAction func saveNewReminder(_ sender: Any) {
        
        let ref = Database.database().reference()
        
        let key = ref.child("users").childByAutoId().key
        
        let dictionaryReminder = [
        
            "title": self.reminderTitle ,
            "details":  self.reminderDetails ,
            "time": self.timeStamp,
            "isComplete": "false"
            
        ]
        
        if let uID = Auth.auth().currentUser?.uid {
            let childUpdates = ["/users/\(uID)/todos/\(key)": dictionaryReminder]
            
            ref.updateChildValues(childUpdates)
            print("Child Updated!")
        }
        
        assignTo()
        
        if self.assignedKeys.count != 0 {

            for userID in self.assignedKeys {
                let path = ["/users/\(userID)/todos/\(key)": dictionaryReminder]
                
                ref.updateChildValues(path)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func assignTodo () {
        
    }
    
 
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func initializeForm() {
        
        form
            +++ Section("Title")    //2
            <<< TextRow() { row in // 3
                row.title = "Title"
                row.tag = "reminderTitle"//4
                row.placeholder = "Meet XYZ"
                //$0.value = viewModel.title //5
                //$0.onChange { [unowned self] row in //6
                //    self.viewModel.title = row.value
                //}
                }.onChange({ (row) in
                    self.reminderTitle = row.value != nil ? row.value! : "" //updating the value on change
                    print(self.reminderTitle)
                    
                })
        
            +++ Section("Alarm")
            <<< DateTimeRow() { row in
                row.title = "Time: "
                row.tag = "reminderTime"
                
            }.onChange({ (row) in
               
                if let timeInDouble = row.value?.timeIntervalSince1970 {
                    self.tempTimeStamp = timeInDouble
                }
                self.timeStamp = String(format: "%.0f", self.tempTimeStamp)
                print(self.timeStamp)
                
                self.reminderDate = row.value
                
            })

            +++ Section("Details")
            <<< TextAreaRow() {
                $0.placeholder = "Carry laptop"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                }.onChange({ (row) in
                    
                    if let tempReminderDetails = row.value {
                        self.reminderDetails = tempReminderDetails
                        
                    }else {
                        print("Failed to save reminder details")
                    }
                    
                })
        
            +++ Section("Assign Task")
            <<< MultipleSelectorRow<String>() { row in
            
                row.title = "Assign to: "
                
                var usersArray = [String]()
                for (_,value) in self.teamDictionary {
                    usersArray.append(value)
                }
                row.options = usersArray
                } .onChange() { (row) in
                    if let selectedValue = row.value {
                        
                        self.assignedTo.removeAll()
                        
                        for users in selectedValue {
                            self.assignedTo.append(users)
                        }
                    }
                }
        


        
    }

    func getTeam() {
        
        let ref = Database.database().reference()
        if let id = Auth.auth().currentUser?.uid {
            ref.child("users/\(id)/team").observe(.value) { (snapshot) in
                
                if snapshot.exists() {
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    
                    for object in snapshots {
//                        let teamObject = object.value as! String
                        
                        let key = object.key
                        let name = object.value as! String
                        
                        self.teamDictionary[key] = name
                        print (self.teamDictionary.values)
                    }
                }
                self.initializeForm()
            }
            }
        
    }
    
    func assignTo() {
        self.assignedKeys.removeAll()
        for (key,value) in self.teamDictionary {
            if self.assignedTo.contains(value) {
                self.assignedKeys.append(key)
            }
            
        }
        print(self.assignedKeys)
    }
    
}



/* SAVING A REMINDER TO EVENT REMINDER:
 
 
 let reminder = EKReminder(eventStore: self.eventStore)
 reminder.title = self.reminderTitle
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 let dueDateComponents = appDelegate.dateComponentFromNSDate(date: NSDate(timeIntervalSince1970: Double(self.tempTimeStamp)))
 
 reminder.dueDateComponents = dueDateComponents as DateComponents
 reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
 // 2
 do {
 try self.eventStore.save(reminder, commit: true)
 dismiss(animated: true, completion: nil)
 }catch{
 print("Error creating and saving new reminder : \(error)")
 }
 
 */
