//
//  LoginViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 08/02/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        if let email = Auth.auth().currentUser?.email {
//            if email != "" {
//                print(email)
////                self.performSegue(withIdentifier: "loggedInSegue", sender: self)
//
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
//                self.present(vc!, animated: true, completion: nil)
//                print("not presented")
//
//            }
//        }
    

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
//        if let email = Auth.auth().currentUser?.email {
//            if email != "" {
//                print(email)
//                self.performSegue(withIdentifier: "loggedInSegue", sender: self)
//            }
//        }
//
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

                
                if error == nil {
                    if let user = Auth.auth().currentUser {
                        if !user.isEmailVerified{
                            let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(self.emailTextField.text).", preferredStyle: .alert)
                            let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                                (_) in
                                user.sendEmailVerification(completion: nil)
                            }
                            let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                            
                            alertVC.addAction(alertActionOkay)
                            alertVC.addAction(alertActionCancel)
                            self.present(alertVC, animated: true, completion: nil)
                        
                        } else {
                            print ("Email Verified, good to go!")
                            let alert = UIAlertController(title: "", message: "Welcome", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            
                            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userDefaultsUID")
                            
                            print("\(UserDefaults.standard.string(forKey: "userDefaultsUID") ?? "user ID NULL")")
                            
                            
                            // change to desired number of seconds (in this case 5 seconds)
                            let when = DispatchTime.now() + 2
                            DispatchQueue.main.asyncAfter(deadline: when){
                                // your code with delay
                                alert.dismiss(animated: true, completion: nil)
                                
                                
                                let addUserDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "addUserDetailsVC")
                        
                                self.present(addUserDetailsVC!, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Incorrect credentials", message:
                        "Please check the entered credentials, and try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }

        }
        
    }
    
    func addToRealm() {
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let email = Auth.auth().currentUser?.email {
            if email != "" {
                print(email)
                //                self.performSegue(withIdentifier: "loggedInSegue", sender: self)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
                self.present(vc!, animated: true, completion: nil)
                print("not presented")
                
            }
        }
    }
}
