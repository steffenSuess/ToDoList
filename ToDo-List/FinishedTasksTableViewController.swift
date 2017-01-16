//
//  FinishedTasksTableViewController.swift
//  ToDo-List
//
//  Created by Steffen Süß on 16.01.17.
//  Copyright © 2017 Steffen Süß. All rights reserved.
//

import UIKit
import CoreData

class FinishedTasksTableViewController: UITableViewController {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var context:NSManagedObjectContext!
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoTask")
    
    var results:[NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = appDelegate.persistentContainer.viewContext
        let predicate = NSPredicate(format: "isDone == %@", true as CVarArg)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do{
            results = try context.fetch(request) as! [NSManagedObject]
        }catch{
            print("Error on saving Core Data")
        }
        
        tableView.reloadData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete){
            if(results.count > 0){
                let result = results[indexPath.row]
                context.delete(result)
                do{
                    try context.save()
                    results = try context.fetch(request) as! [NSManagedObject]
                    self.tableView.reloadData()
                }catch{
                    print("Error on saving Core Data")
                }
                tableView.reloadData()
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinishedTaskCell", for: indexPath)
        
        if results.count > 0 {
            let cellSwitch = UISwitch()
            cellSwitch.isOn = true
            cellSwitch.addTarget(self, action: #selector(taskIsDone(sender:)), for: .valueChanged)
            cellSwitch.tag = indexPath.row
            cell.accessoryView = cellSwitch
            let result = results[indexPath.row]
            cell.textLabel?.text = result.value(forKey: "name") as! String?
        }
        
        return cell
    }
    
    func taskIsDone(sender: UISwitch){
        let result = results[sender.tag]
        result.setValue(false, forKey: "isDone")
        do{
            try context.save()
            results = try context.fetch(request) as! [NSManagedObject]
            tableView.reloadData()
        }catch{
            
        }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
