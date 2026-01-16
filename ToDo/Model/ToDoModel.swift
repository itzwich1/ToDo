//
//  ToDoModel.swift
//  ToDo
//
//  Created by Felix Wich on 08.01.26.
//

import Foundation
import SwiftData
import SwiftUI



enum Category: Int, Codable, CaseIterable, Identifiable{
    
    case privat = 1
    case haushalt = 2
    case schule = 3
    case arbeit = 4
    
    var id: Int { rawValue }
    
    
    var title: String {
        switch self {
        case .privat: return "Privat"
        case .haushalt: return "Haushalt"
        case .schule: return "Schule"
        case .arbeit: return "Arbeit"
        }
    }
    
}

enum Priority: Int, Codable, CaseIterable, Identifiable, Comparable{
    
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
    var category: Category?
    
    @Attribute(.externalStorage) var attachment: Data?
    var attachmentName: String?
    
    
    init(timestamp: Date, title: String = "", isCompleted: Bool = false, notes: String = "", priority: Priority = .medium, dueDate: Date = Date(), hasDueDate: Bool = false, hasAnyTime: Bool = false, attachment: Data? = nil, attachmentName: String? = nil, category: Category? = nil) {
        self.timestamp = timestamp
        self.title = title
        self.isCompleted = isCompleted
        self.notes = notes
        self.priority = priority
        self.dueDate = dueDate
        self.hasDueDate = hasDueDate
        self.hasAnyTime = hasAnyTime
        self.attachment = attachment
        self.attachmentName = attachmentName
        self.category = category
    }
}
