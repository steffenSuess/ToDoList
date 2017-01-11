//
//  TodoItem.swift
//  ToDo-List
//
//  Created by Steffen Süß on 11.01.17.
//  Copyright © 2017 Steffen Süß. All rights reserved.
//

import UIKit

class TodoItem: NSObject {
    let itemName: String
    var completed: Bool
    
    init(itemName: String, completed: Bool = false) {
        self.itemName = itemName
        self.completed = completed
    }

}
