//
//  SignUpViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 14/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuthUI
import Firebase

class SignUpViewController: FormViewController {

    var firstname: String = ""
    var lastname: String = ""
    var email: String = ""
    var pass: String = ""
    var confirmPass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeForm()
        // Do any additional setup after loading the view.
    }
    
    func initializeForm() {

          form +++ Section("Email")
            <<< TextRow() { row in
                    row.title = ".net Email"
                    row.add(rule: RuleRequired())
                    row.add(rule: RuleEmail())
                    row.validationOptions = .validatesOnChangeAfterBlurred
                }            .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                } .onChange({ (row) in
                    self.email = row.value != nil ? row.value! : ""
                    print(self.email)
                })
        
        +++ Section("Password")
            <<< PasswordRow() { row in
                    row.title = "Password"
                    row.placeholder = "abcd@1234"
                } .onChange({ (row) in
                    self.pass = row.value != nil ? row.value! : ""
                    print(self.pass)
                })
        
        +++ Section("Confirm Password")
            <<< PasswordRow { row in
                    row.title = "Confirm password"
            
                } .onChange({ (row) in
                    self.confirmPass = row.value != nil ? row.value! : ""
                    print(self.confirmPass)
                })
        
        
    }

    
    @IBAction func verifyButton(_ sender: Any) {
        
        if validateFields() {
            
            Auth.auth().createUser(withEmail: self.email, password: self.pass, completion: { (error, result) -> Void in
                
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    // ...
                    let alertVC = UIAlertController(title: "", message: "A verification email has been sent to \(self.email)", preferredStyle: .alert)
                    let alertActionDismiss = UIAlertAction(title: "Dismiss", style: .default) {
                        (_) in

                        self.dismiss(animated: true, completion: nil)
                        
                    }

                    alertVC.addAction(alertActionDismiss)
                    self.present(alertVC, animated: true, completion: nil)
                }

            })
            
        }
        
    }
    
    func validateFields() -> Bool {
        
        if (self.email == "" || self.pass != self.confirmPass || self.pass == "" || !isValidEmailAddress(emailAddressString: self.email)){
            
            let alert = UIAlertController(title: "Error", message: "Invalid information in one or more fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The dismiss alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
            return false
        } else {
            print("Correct details entered, now wait for verification email")
            return true
        }
        
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@aiesec.net"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }

    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
