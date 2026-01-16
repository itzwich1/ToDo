//
//  OpenToDoElement.swift
//  ToDo
//
//  Created by Felix Wich on 16.01.26.
//

import SwiftData
import SwiftUI

struct OpenToDoElement: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var items: [ToDoModel]
    
    var body: some View {
        
        Section("Offene Aufgaben") {
            ForEach(items.filter{!$0.isCompleted}){ item in
                NavigationLink(value: item){
                    HStack {
                        Text(item.title)
                        
                        Spacer()
                        
                        // Dein Wichtigkeits-Icon
                        if item.priority == .high {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(.red)
                        }
                        
                        // Info, falls Termin heute ist (Optional, sieht aber gut aus)
                        if item.hasDueDate {
                            Text("Fällig bis \(item.dueDate.formatted(date: .numeric, time: .omitted))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }.swipeActions(edge: .leading){
                    
                    Button(role: .destructive, action: {
                        modelContext.delete(item)
                    }) {
                        Image(systemName: "trash")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40) // Feste Größe erzwingen
                            .background(.green)
                            .clipShape(Circle())
                    }
                    
                    if !item.isCompleted {
                        Button(role: .confirm, action: {
                            item.isCompleted = true
                        }) {
                            Image(systemName: "checkmark")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40) // Feste Größe erzwingen
                                .background(.green)
                                .clipShape(Circle())
                        }.tint(.green)
                    }
                }
            }
        }
    }
}
