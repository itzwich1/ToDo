//
//  ToDoModel.swift
//  ToDo
//
//  Created by Felix Wich on 08.01.26.
//

import Foundation
import SwiftData
import SwiftUI

enum Priority: Int, Codable, CaseIterable, Identifiable{
    
    case low = 1
    case medium = 2
    case high = 3
    
    
    // Für Identifiable (Pflicht)
    var id: Int { rawValue }
    
    // WICHTIG: Die Text-Darstellung für den Nutzer
    var title: String {
        switch self {
        case .high: return "Hoch"
        case .medium: return "Mittel"
        case .low: return "Niedrig"
        }
    }
    
    // WICHTIG: Die Farbe für die UI (z.B. der kleine Punkt in der Liste)
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        
        }
    }
    
    static func < (lhs: Priority, rhs: Priority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
}

@Model
final class ToDoModel {
    var timestamp: Date
    var title: String
    var isCompleted: Bool
    var notes: String
    var priority: Priority
    
    //Optional noch nicht sicher
    var dueDate: Date
    var hasDueDate: Bool
    var hasAnyTime: Bool
    //var category: String //ggf. auch als Enum (3-5 Kategorien vorgeben)
    
    
    init(timestamp: Date, title: String = "", isCompleted: Bool = false, notes: String = "", priority: Priority = .medium, dueDate: Date = Date(), hasDueDate: Bool = false, hasAnyTime: Bool = false) {
        self.timestamp = timestamp
        self.title = title
        self.isCompleted = isCompleted
        self.notes = notes
        self.priority = priority
        self.dueDate = dueDate
        self.hasDueDate = hasDueDate
        self.hasAnyTime = hasAnyTime
    }
}
