//
//  TodoItem.swift
//  ToDo-List
//
//  Created by Steffen Süß on 11.01.17.
//  Copyright © 2017 Steffen Süß. All rights reserved.
//

import UIKit
import MapKit

class TodoItem: NSObject {
    var itemName: String
    var completed: Bool
    var pointAnnotation: MKPointAnnotation?
    var date: Date?
    var note: String?
    
    init(itemName: String, completed: Bool = false) {
        self.itemName = itemName
        self.completed = completed
    }
}
