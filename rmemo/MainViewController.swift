//
//  MainViewController.swift
//  rmemo
//
//  Created by obata on 2017/04/20.
//  Copyright © 2017年 obata. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications


class DataObject: Object {
    dynamic var id = UUID().uuidString
    dynamic var name = ""
    dynamic var value  = ""
    dynamic var date = NSDate()
    
}


class MainViewController: UITableViewController {
    
    let results = try! Realm().objects(DataObject.self)
    
    
    var notificationToken: NotificationToken?

    
    let dataList = [(name:"abc",value:"def"),(name:"123",value:"456")]


    override func viewDidLoad() {
        super.viewDidLoad()

        
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge], completionHandler:{(permit,error ) in
            
            
        } )
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.notificationToken = results.addNotificationBlock{ (changes: RealmCollectionChange) in
            switch changes {
            case .initial :
                self.tableView.reloadData()
                break
            case .update(_, let deletions,let insertions,let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map{IndexPath(row: $0,section:0)}, with: .automatic)
                self.tableView.deleteRows(at: deletions.map{IndexPath(row: $0,section:0)}, with: .automatic)
                self.tableView.reloadRows(at: modifications.map{IndexPath(row: $0,section:0)}, with: .automatic)
            case .error(let err):
                fatalError("\(err)")
                break
                
            }
        }
        
        DispatchQueue.global().async {
            let realm = try! Realm()
            
            realm.beginWrite()
            realm.deleteAll()
            for data in self.dataList{
                realm.create(DataObject.self,value:["name":data.name,"value":data.value])
            }
            try! realm.commitWrite()
        }

        
        
        
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
        return results.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let data = results[(indexPath as NSIndexPath).row]
        
        
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.id
        
        return cell

    }
    

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier  {
            if id == "ShowPage" {
                if let indexPath = self.tableView.indexPathForSelectedRow{
                    let data = results[(indexPath as NSIndexPath).row]
                    (segue.destination as! ViewController).setText(text:data.value)
                    
                }
                
            }
        }
        
    }
    

}
