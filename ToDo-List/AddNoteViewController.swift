//
//  AddNoteViewController.swift
//  ToDo-List
//
//  Created by Steffen Süß on 14.01.17.
//  Copyright © 2017 Steffen Süß. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var tvNote: UITextView!
    var currentNote: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvNote.becomeFirstResponder()
        
        if currentNote != nil{
            tvNote.text = currentNote!
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Löschen", style: .plain, target: self, action: #selector(doPerformSegue))
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doPerformSegue(){
        self.performSegue(withIdentifier: "unwindNoteToList", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(navigationItem.leftBarButtonItem?.title == "Löschen" && segue.identifier == "unwindNoteToList"){
            let controller = segue.destination as! AddItemTableViewController
            controller.todoItem.note = nil
            let indexpath = IndexPath(row: 0, section: 1)
            let cell = controller.tableView.cellForRow(at: indexpath)
            cell?.textLabel?.text = "Notiz..."
            cell?.textLabel?.textColor = UIColor.lightGray
            controller.tableView.reloadData()
        }
    }
    

}
