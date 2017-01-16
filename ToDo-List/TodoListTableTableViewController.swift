//
//  TodoListTableTableViewController.swift
//  ToDo-List
//
//  Created by Steffen Süß on 11.01.17.
//  Copyright © 2017 Steffen Süß. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TodoListTableTableViewController: UITableViewController, UIAlertViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var context:NSManagedObjectContext!
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoTask")
    
    var results:[NSManagedObject] = []
    
    var overdueResults:[NSManagedObject] = []
    var todaysResults:[NSManagedObject] = []
    var tomorrowsResults:[NSManagedObject] = []
    var soonResults:[NSManagedObject] = []
    var sometimesResults:[NSManagedObject] = []

    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        print("Unwinding")
    }
    
    @IBAction func unwindAndAddToList(segue: UIStoryboardSegue) {
        let source = segue.source as! AddItemTableViewController
        let todoItem:TodoItem = source.todoItem
        
        
        
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "ToDoTask", into: context)
        
        newTask.setValue(todoItem.itemName, forKey: "name")
        if(todoItem.note != nil){
            newTask.setValue(todoItem.note, forKey: "note")
        }
        if(todoItem.date != nil){
            newTask.setValue(todoItem.date, forKey: "date")
        }
        if(todoItem.pointAnnotation != nil){
            newTask.setValue(todoItem.pointAnnotation?.title, forKey: "locationTitle")
            newTask.setValue(Double((todoItem.pointAnnotation?.coordinate.latitude)!), forKey: "latitude")
            newTask.setValue(Double((todoItem.pointAnnotation?.coordinate.longitude)!), forKey: "longitude")
            if(todoItem.pointAnnotation?.subtitle != nil){
                newTask.setValue(todoItem.pointAnnotation?.subtitle, forKey: "locationSubtitle")
            }
        }
        
        do{
            try context.save()
            print("Saved")
        }catch{
            
        }
        refreshTableViewData(indexPath: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        let predicate = NSPredicate(format: "isDone == %@", false as CVarArg)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do{
            results = try context.fetch(request) as! [NSManagedObject]
        }catch{
            print("Error on saving Core Data")
        }
        
        refreshTableViewData(indexPath: nil)
        
        
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Überfällig"
        case 1:
            return "Heute"
        case 2:
            return "Morgen"
        case 3:
            return "Demnächst"
        case 4:
            return "Irgendwann"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return self.overdueResults.count
        case 1:
            return self.todaysResults.count
        case 2:
            return self.tomorrowsResults.count
        case 3:
            return self.soonResults.count
        case 4:
            return self.sometimesResults.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if self.overdueResults.count == 0{
                return 0.0
            }
        case 1:
            if self.todaysResults.count == 0 {
                return 0.0
            }
        case 2:
            if self.tomorrowsResults.count == 0 {
                return 0.0
            }
        case 3:
            if self.soonResults.count == 0{
                return 0.0
            }
        case 4:
            if self.sometimesResults.count == 0{
                return 0.0
            }
        default:
            return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempCell = tableView.dequeueReusableCell(withIdentifier: "ListPrototypeCell")! as UITableViewCell
        let cellSwitch = UISwitch()
        cellSwitch.isOn = false
        cellSwitch.addTarget(self, action: #selector(taskIsDone(sender:)), for: .valueChanged)
        tempCell.accessoryView = cellSwitch
        // Downcast from UILabel? to UILabel
        let cell = tempCell.textLabel as UILabel!
        //cell?.text = todoItem.itemName
        var result: NSManagedObject?
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        switch indexPath.section {
        case 0:
            if self.overdueResults.count > 0{
                result = self.overdueResults[indexPath.row]
                tempCell.detailTextLabel?.text = formatter.string(from: result?.value(forKey: "date") as! Date)
                tempCell.detailTextLabel?.textColor = UIColor.red
            }
            break
        case 1:
            if self.todaysResults.count > 0{
                result = self.todaysResults[indexPath.row]
                tempCell.detailTextLabel?.text = formatter.string(from: result?.value(forKey: "date") as! Date)
            }
            break
        case 2:
            if self.tomorrowsResults.count > 0{
                result = self.tomorrowsResults[indexPath.row]
                tempCell.detailTextLabel?.text = formatter.string(from: result?.value(forKey: "date") as! Date)
            }
            break
        case 3:
            if self.soonResults.count > 0{
                result = self.soonResults[indexPath.row]
                tempCell.detailTextLabel?.text = formatter.string(from: result?.value(forKey: "date") as! Date)
            }
            break
        case 4:
            if self.sometimesResults.count > 0{
                result = self.sometimesResults[indexPath.row]
            }
            break
        default:
            result = nil
            break
        }

        
        if(result != nil){
            cell?.text = result?.value(forKey: "name") as! String?
        }
        //let todoItem = todoItems[indexPath.row]
        
        
        
        //if (todoItem.completed) {
            //tempCell.accessoryType = UITableViewCellAccessoryType.checkmark;
        //} else {
            //tempCell.accessoryType = UITableViewCellAccessoryType.none;
        //}
        
        return tempCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTask", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete){
            var result:NSManagedObject?
            switch indexPath.section {
            case 0:
                
                result = self.overdueResults[indexPath.row]
                
                break
            case 1:
                
                result = self.todaysResults[indexPath.row]
                
                break
            case 2:
                
                result = self.tomorrowsResults[indexPath.row]
                
                break
            case 3:
                
                result = self.soonResults[indexPath.row]
                
                break
            case 4:
                
                result = self.sometimesResults[indexPath.row]
                
                break
            default:
                result = nil
                break
            }
            if(result != nil){
                context.delete(result!)
                do{
                    try context.save()
                    refreshTableViewData(indexPath: indexPath)
                }catch{
                    print("Error on saving Core Data")
                }
                
            }
        }
    }
    
    func taskIsDone(sender: UISwitch){
        let cell = sender.superview as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        let result:NSManagedObject?
        if(indexPath != nil){
            switch indexPath!.section {
            case 0:
                
                result = self.overdueResults[indexPath!.row]
                
                break
            case 1:
                
                result = self.todaysResults[indexPath!.row]
                
                break
            case 2:
                
                result = self.tomorrowsResults[indexPath!.row]
                
                break
            case 3:
                
                result = self.soonResults[indexPath!.row]
                
                break
            case 4:
                
                result = self.sometimesResults[indexPath!.row]
                
                break
            default:
                result = nil
                break
            }
            if(result != nil){
                result!.setValue(true, forKey: "isDone")
                do{
                    try context.save()
                    refreshTableViewData(indexPath: indexPath)
                    
                }catch{
                    
                }
            }
            
        }
    }
    
    func refreshTableViewData(indexPath: IndexPath?){
        overdueResults = []
        todaysResults = []
        tomorrowsResults = []
        soonResults = []
        sometimesResults = []
        do{
            results = try context.fetch(request) as! [NSManagedObject]
        }catch{
            print("Error on saving Core Data")
        }
        if(results.count > 0){
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateStyle = DateFormatter.Style.short
            for result in results{
                let date = result.value(forKey: "date") as? Date
                if(date != nil){
                    if(dateFormatter.string(from: date!) == dateFormatter.string(from: Date())){
                        self.todaysResults.append(result)
                    }else if(dateFormatter.string(from: date!) == dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: +1, to: Date())!)){
                        self.tomorrowsResults.append(result)
                    }else if(date! > Date()){
                        self.soonResults.append(result)
                    }else{
                        self.overdueResults.append(result)
                    }
                }else{
                    self.sometimesResults.append(result)
                }
            }
        }
        if(indexPath == nil){
            self.tableView.reloadData()
        }else{
            for test in self.tableView.visibleCells{
                test.detailTextLabel?.text = ""
                test.detailTextLabel?.textColor = UIColor.darkText
            }
            //let cell = self.tableView.cellForRow(at: indexPath!)
            //cell?.detailTextLabel?.text = ""
            self.tableView.reloadData()
            //self.tableView.reloadSections([section!], with: .automatic)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? IndexPath
        if(segue.identifier == "showTask" && index != nil){
            do{
                let controller = segue.destination as! UINavigationController
                let taskController = controller.topViewController as! AddItemTableViewController
                
                let result:NSManagedObject?
                
                switch index!.section {
                case 0:
                    
                    result = self.overdueResults[index!.row]
                    
                    break
                case 1:
                    
                    result = self.todaysResults[index!.row]
                    
                    break
                case 2:
                    
                    result = self.tomorrowsResults[index!.row]
                    
                    break
                case 3:
                    
                    result = self.soonResults[index!.row]
                    
                    break
                case 4:
                    
                    result = self.sometimesResults[index!.row]
                    
                    break
                default:
                    result = nil
                    break
                }
                
                
                if(result != nil){
                    taskController.todoItem = TodoItem(itemName: result!.value(forKey: "name") as! String)
                    let note = result!.value(forKey: "note") as? String
                    if(note != nil){
                        taskController.todoItem.note = note
                    }
                    let date = result!.value(forKey: "date") as? Date
                    if(date != nil){
                        taskController.todoItem.date = date
                    }
                    let locationTitle = result!.value(forKey: "locationTitle") as? String
                    if(locationTitle != nil){
                        let pointAnnotation = MKPointAnnotation()
                        pointAnnotation.title = locationTitle
                        pointAnnotation.coordinate.latitude = result!.value(forKey: "latitude") as! CLLocationDegrees
                        pointAnnotation.coordinate.longitude = result!.value(forKey: "longitude") as! CLLocationDegrees
                        let locationSubtitle = result!.value(forKey: "locationSubtitle") as? String
                        if(locationSubtitle != nil){
                            pointAnnotation.subtitle = locationSubtitle
                        }
                        taskController.todoItem.pointAnnotation = pointAnnotation
                    }
                    context.delete(result!)
                    try context.save()
                }
                refreshTableViewData(indexPath: index)
            }catch{}
        }
    }

}
