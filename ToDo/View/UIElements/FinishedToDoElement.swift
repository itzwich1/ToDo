//
//  FilterElement.swift
//  ToDo
//
//  Created by Felix Wich on 16.01.26.
//

import SwiftUI
import SwiftData


struct FinishedToDoElement: View {
    
    @Environment(\.modelContext) private var modelContext
        
        var items: [ToDoModel]
        
        var body: some View {
            
            
            let finishedItems = items.filter { $0.isCompleted }
            
            if !finishedItems.isEmpty {
                Section("Erledigt") {
                    ForEach(finishedItems) { item in
                        NavigationLink(value: item) {
                            HStack {
                                Text(item.title)
                                    .strikethrough()
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .swipeActions(edge: .leading) {
                            // Löschen
                            Button(role: .destructive) {
                                modelContext.delete(item)
                            } label: {
                                Label("",systemImage: "trash")
                            }
                            
                            // Wiederherstellen
                            Button {
                                withAnimation {
                                    item.isCompleted = false
                                }
                            } label: {
                                Label("",systemImage: "arrow.uturn.backward")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
        }
}
