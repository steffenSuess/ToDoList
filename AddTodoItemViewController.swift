//
//  AddTodoItemViewController.swift
//  ToDo-List
//
//  Created by Steffen Süß on 11.01.17.
//  Copyright © 2017 Steffen Süß. All rights reserved.
//

import UIKit

class AddTodoItemViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var todoItem: TodoItem = TodoItem(itemName: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if((self.textField.text?.characters.count)! > 0){
            self.todoItem = TodoItem(itemName: self.textField.text!)
        }
    }
    

}
