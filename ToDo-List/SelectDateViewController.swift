//
//  SelectDateViewController.swift
//  ToDo-List
//
//  Created by Steffen Süß on 13.01.17.
//  Copyright © 2017 Steffen Süß. All rights reserved.
//

import UIKit

class SelectDateViewController: UIViewController {
    
    @IBOutlet weak var dpSelectDate: UIDatePicker!
    var currentDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        if currentDate != nil{
            dpSelectDate.date = currentDate!
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Löschen", style: .plain, target: self, action: #selector(doPerformSegue))
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doPerformSegue(){
        self.performSegue(withIdentifier: "unwindToList", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(navigationItem.leftBarButtonItem?.title == "Löschen" && segue.identifier == "unwindToList"){
            let controller = segue.destination as! AddItemTableViewController
            controller.todoItem.date = nil
            let indexpath = IndexPath(row: 0, section: 1)
            let cell = controller.tableView.cellForRow(at: indexpath)
            cell?.detailTextLabel?.text = ""
        }
    }
    

}
