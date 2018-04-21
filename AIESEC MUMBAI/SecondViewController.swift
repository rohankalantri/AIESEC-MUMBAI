//
//  SecondViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 08/02/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import EventKit
import Firebase

struct reminder {
    var title: String
    var time: String
    var details: String
    var isComplete: String
    var key: String
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var reminderList = [reminder]()
    
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        loadReminders()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        loadReminders()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "reminderCell")
        
        let currentReminder = self.reminderList[indexPath.row]
        cell.textLabel?.text = currentReminder.title
        cell.detailTextLabel?.text = getTime(timeStamp: currentReminder.time)
        return cell
        
    }
    

    
    @IBAction func editButton(_ sender: Any) {
        
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing{
            tableView.setEditing(true, animated: true)
        }else{
            tableView.setEditing(false, animated: true)
        }
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let newReminderVC = segue.destination as! NewReminderViewController
        newReminderVC.eventStore = eventStore
    }
    
    func loadReminders() {
        
        let ref = Database.database().reference()
        if let uID = Auth.auth().currentUser?.uid {
            ref.child("users/\(uID)/todos").observe(.value) { (snapshot) in
                self.reminderList.removeAll()
                if snapshot.exists() {
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    for object in snapshots {
                        var reminderObject = object.value as! [String:AnyObject]
                        let currentReminder = reminder(title: reminderObject["title"] as! String,
                                                       time: reminderObject["time"] as! String,
                                                       details: reminderObject["details"] as! String,
                                                       isComplete: reminderObject["isComplete"] as! String,
                                                       key: object.key)

                        if currentReminder.isComplete == "false" {
                            self.reminderList.append(currentReminder)
                        }
//                        print(self.reminderList)
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        let key = self.reminderList[indexPath.row].key
        let ref = Database.database().reference()
        
        if let uID = Auth.auth().currentUser?.uid {
            let todoUpdate = ["users/\(uID)/todos/\(key)/isComplete": "true"]
            ref.updateChildValues(todoUpdate)
//            ref.child("users/\(uID)/todos/\(key)/isComplete").setValue("true");
//            loadReminders()
//            self.tableView.reloadData()
        }
//        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation .fade)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let reminderDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "reminderDetailsVC") as! ReminderDetailsViewController
        reminderDetailsVC.currentReminder.title = self.reminderList[indexPath.row].title
        reminderDetailsVC.currentReminder.details = self.reminderList[indexPath.row].details
        reminderDetailsVC.currentReminder.timeStamp = self.reminderList[indexPath.row].time
        
        self.navigationController?.pushViewController(reminderDetailsVC, animated: true)
    }
    
}


/* Getting Reminders from the reminders app :
 
 let reminder:EKReminder! = self.reminders![indexPath.row]
 cell.textLabel?.text = reminder.title
 let formatter:DateFormatter = DateFormatter()
 formatter.dateFormat = "dd-MM-yyyy"
 if let dueDate = reminder.dueDateComponents?.date{
 cell.detailTextLabel?.text = formatter.string(from: dueDate)
 }else{
 cell.detailTextLabel?.text = "N/A"
 }
 
 */

/* MARK: Request Access to Event Kit Reminders:
 Put in viewWillAppear:
 
 self.eventStore = EKEventStore()
 self.reminders = [EKReminder]()
 self.eventStore.requestAccess(to: EKEntityType.reminder, completion: {
 (granted, error) in
 
 if granted{
 // 2
 let predicate = self.eventStore.predicateForReminders(in: nil)
 self.eventStore.fetchReminders(matching: predicate, completion: { (reminders: [EKReminder]?) -> Void in
 
 self.reminders = reminders
 DispatchQueue.main.async() {
 self.tableView.reloadData()
 }
 })
 }else{
 print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
 }
 })
 
 */

//
//func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//    let reminder: EKReminder = reminders[indexPath.row]
//    do{
//        try eventStore.remove(reminder, commit: true)
//        self.reminders.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
//    }catch{
//        print("An error occurred while removing the reminder from the Calendar database: \(error)")
//    }
//}

