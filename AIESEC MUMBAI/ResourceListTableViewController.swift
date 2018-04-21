//
//  ResourceListTableViewController.swift
//  AIESEC MUMBAI
//
//  Created by Rohan Kalantri on 22/03/18.
//  Copyright © 2018 Rohan Kalantri. All rights reserved.
//

import UIKit
import Firebase


struct Documents {
    var name: String = ""
    var link: String = ""
}

class ResourceListTableViewController: UITableViewController {

    var departmentName: String!
    var docs = [Documents]()
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.docs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doclistCell")
        
        cell?.textLabel?.text = self.docs[indexPath.row].name
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let webVC = self.storyboard?.instantiateViewController(withIdentifier: "webVC") as! WebViewController
        
        webVC.link = self.docs[indexPath.row].link
        print (self.docs[indexPath.row].link)
        navigationController?.pushViewController(webVC, animated: true)
        
    }
    
    func loadData() {
        self.docs.removeAll()
        print(self.departmentName)
        self.titleLabel.title = self.departmentName
        let ref = Database.database().reference()
        if let departmentNameTemp = self.departmentName {
         
            ref.child("resources/\(departmentNameTemp)").observe(.value) { (snapshot) in
                
                if snapshot.exists() {
                    let snapshots = snapshot.children.allObjects as! [DataSnapshot]
                    for object in snapshots {
                        //                    var resourceObject = object as! [String:AnyObject]
                        
                        var docDictionary = Documents()
                        
                        docDictionary.name = object.key
                        docDictionary.link = object.value as! String
                        
                        self.docs.append(docDictionary)
                        
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
