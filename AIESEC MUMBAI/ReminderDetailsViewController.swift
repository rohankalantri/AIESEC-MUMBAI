//
//  ReminderDetailsViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 27/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import Eureka

struct reminderDetails {
    var title: String = ""
    var details: String = ""
    var timeStamp: String = ""
    
}

class ReminderDetailsViewController: FormViewController {

    var currentReminder = reminderDetails()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
        // Do any additional setup after loading the view.
    }

    func initializeForm() {
        
        form
            +++ Section("Title")    //2
            <<< TextRow() { row in // 3
                row.title = "Title"
                row.tag = "reminderTitle"//4
                row.placeholder = "Meet XYZ"
                row.value = self.currentReminder.title
                row.disabled = true
                }
            
            +++ Section("Alarm")
            <<< DateTimeRow() { row in
                row.title = "Time: "
                row.tag = "reminderTime"
                row.value = getTime(timeStamp: self.currentReminder.timeStamp)
                row.disabled = true
                }
            
            +++ Section("Details")
            <<< TextAreaRow() {
                $0.placeholder = "Carry laptop"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.value = self.currentReminder.details
                $0.disabled = true
                }
        
    }
    
    func getTime(timeStamp: String) -> Date {
        
        if let tempTimeStamp = Double(timeStamp) {
            let date = Date(timeIntervalSince1970: tempTimeStamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: String(describing: TimeZone.current)) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            return dateFormatter.date(from: strDate)!
        }
        
        return Date()
    }
}
