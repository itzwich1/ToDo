//
//  ToDoModel.swift
//  ToDo
//
//  Created by Felix Wich on 08.01.26.
//

import Foundation
import SwiftData
import SwiftUI

enum Priority: Int, Codable{
    case high = 1
    case medium = 2
    case low = 3
}

@Model
final class ToDoModel {
    var timestamp: Date
    var title: String
    var isCompleted: Bool
    var notes: String
    var priority: Priority
    
    //Optional noch nicht sicher
    //var dueDate: Date
    //var category: String //ggf. auch als Enum (3-5 Kategorien vorgeben)
    
    
    init(timestamp: Date, title: String = "", isCompleted: Bool = false, notes: String = "", priority: Priority) {
        self.timestamp = timestamp
        self.title = title
        self.isCompleted = isCompleted
        self.notes = notes
        self.priority = priority
    }
}
