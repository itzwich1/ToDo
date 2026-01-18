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
    
    var filteredCategory: Category?
    
    var body: some View {
        
        Section("Offene Aufgaben") {
            
            let filteredItems = items.filter{ item in
                
                let isNotCompleted = !item.isCompleted
                
                let matchesCategory = (filteredCategory == nil || item.category == filteredCategory)
                
                return isNotCompleted && matchesCategory
            }
            
            ForEach(filteredItems){ item in
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
                        
                        //Benachrichtigung fuer ToDo entfernen
                        NotificationManager.instance.cancelNotification(for: item)
                        
                        modelContext.delete(item)
                    }) {
                        Image(systemName: "trash")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.green)
                            .clipShape(Circle())
                    }
                    
                    if !item.isCompleted {
                        Button(role: .confirm, action: {
                            
                            item.isCompleted = true
                            
                            //Benachrichtigung fuer ToDo entfernen
                            NotificationManager.instance.cancelNotification(for: item)
                        }) {
                            Image(systemName: "checkmark")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(.green)
                                .clipShape(Circle())
                        }.tint(.green)
                    }
                }
            }
        }
    }
}
