//
//  AddItemTableViewController.swift
//  ToDo-List
//
//  Created by Steffen Süß on 11.01.17.
//  Copyright © 2017 Steffen Süß. All rights reserved.
//

import UIKit
import MapKit

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {
    
    var todoItem: TodoItem!
    
    @IBOutlet weak var tfTitleTextField: UITextField!
    @IBOutlet weak var tvcNote: UITableViewCell!
    @IBOutlet weak var tvcDate: UITableViewCell!
    @IBOutlet weak var tvcLocation: UITableViewCell!
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        print("Unwinding")
    }
    
    @IBAction func unwindAndAddNote(segue: UIStoryboardSegue) {
        let source = segue.source as! AddNoteViewController
        let note:String = source.tvNote.text
        self.todoItem.note = note
        tvcNote.textLabel?.text = self.todoItem.note
        tvcNote.textLabel?.textColor = UIColor.darkText
        self.tableView.reloadData()
    }
    
    @IBAction func unwindAndAddDate(segue: UIStoryboardSegue) {
        let source = segue.source as! SelectDateViewController
        let date:Date = source.dpSelectDate.date
        self.todoItem.date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        tvcDate.textLabel?.text = formatter.string(from: self.todoItem.date!)
        tvcDate.textLabel?.textColor = UIColor.darkText
    }
    
    
    @IBAction func unwindAndAddLocation(segue: UIStoryboardSegue) {
        let source = segue.source as! MapKitViewController
        if(source.pointAnnotation != nil){
            let location:MKPointAnnotation = source.pointAnnotation
            self.todoItem.pointAnnotation = location
            tvcLocation.textLabel?.text = self.todoItem.pointAnnotation?.title
            tvcLocation.textLabel?.textColor = UIColor.darkText
            if(self.todoItem.pointAnnotation?.subtitle != nil){
                tvcLocation.detailTextLabel?.text = self.todoItem.pointAnnotation?.subtitle
            }
            self.tableView.reloadData()
        }
        //        let source = segue.source as! MapKitViewController
        //        let indexpath = IndexPath(row: 0, section: 3)
        //        let cell = tableView.cellForRow(at: indexpath)
        //        if(source.pointAnnotation != nil && !(source.pointAnnotation.title?.isEmpty)!){
        //            let pointAnnotation:MKPointAnnotation = source.pointAnnotation
        //            self.todoItem.pointAnnotation = pointAnnotation
        //            cell?.textLabel?.text = self.todoItem.pointAnnotation?.title
        //            cell?.textLabel?.textColor = UIColor.darkText
        //            if(!(self.todoItem.pointAnnotation?.subtitle?.isEmpty)!){
        //                cell?.detailTextLabel?.text = pointAnnotation.subtitle!
        //            }
        //            self.tableView.reloadData()
        //
        //        }else{
        //            cell?.textLabel?.text = "Standort..."
        //            cell?.textLabel?.textColor = UIColor.lightGray
        //            cell?.detailTextLabel?.text = ""
        //            self.todoItem.pointAnnotation = nil
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.isEnabled = false;
        tfTitleTextField.delegate = self
        tfTitleTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
        if(self.todoItem != nil){
            tfTitleTextField.text = self.todoItem.itemName
            if self.todoItem.note != nil{
                tvcNote.textLabel?.text = self.todoItem.note
                tvcNote.textLabel?.textColor = UIColor.darkText
                
            }
            if self.todoItem.date != nil{
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                tvcDate.textLabel?.text = formatter.string(from: self.todoItem.date!)
                tvcDate.textLabel?.textColor = UIColor.darkText
            }
            if self.todoItem.pointAnnotation != nil{
                tvcLocation.textLabel?.text = self.todoItem.pointAnnotation?.title
                tvcLocation.textLabel?.textColor = UIColor.darkText
                if(self.todoItem.pointAnnotation?.subtitle != nil){
                    tvcLocation.detailTextLabel?.text = self.todoItem.pointAnnotation?.subtitle
                }
            }
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Löschen", style: .plain, target: self, action: #selector(doPerformSegue))
        }else{
            todoItem = TodoItem(itemName: "")
            tfTitleTextField.becomeFirstResponder()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !(tfTitleTextField.text?.isEmpty)!{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    func textFieldDidChange(sender: UITextField) {
        if sender.text != nil && !(sender.text?.isEmpty)! {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func doPerformSegue(){
        self.performSegue(withIdentifier: "unwindToTaskList", sender: self)
    }
    
    
    
    /*
     // MARK: - Table view data source
     
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }
     */
    
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (self.todoItem.pointAnnotation != nil && segue.identifier == "showMapKitView") {
            
            let controller = segue.destination as! UINavigationController
            let mapKitViewController = controller.topViewController as! MapKitViewController
            mapKitViewController.pointAnnotation = self.todoItem.pointAnnotation
        }else if(self.todoItem.date != nil && segue.identifier == "showDateView"){
            let controller = segue.destination as! UINavigationController
            let selectDateViewController = controller.topViewController as! SelectDateViewController
            selectDateViewController.currentDate = self.todoItem.date!
        }else if (self.todoItem.note != nil && segue.identifier == "showNoteView"){
            let controller = segue.destination as! UINavigationController
            let selectDateViewController = controller.topViewController as! AddNoteViewController
            selectDateViewController.currentNote = self.todoItem.note!
        }else if(segue.identifier == "unwindAndAddToListWithSegue"){
            self.todoItem.itemName = tfTitleTextField.text!
        }
    }
    
    
}
