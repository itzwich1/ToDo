//
//  ContentView.swift
//  ToDo
//
//  Created by Felix Wich on 08.01.26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ToDoModel]
    
    @State private var selectedItem: ToDoModel?
    
    
    @State private var showAddSheet: Bool = false
    
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedItem) {
                ForEach(items) { item in
                    NavigationLink(value: item){
                        Text("Item at \(item.title)")
                        
                        EditToDoView(toDo: item)
                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { showAddSheet = true }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }.sheet(isPresented: $showAddSheet){
                
                AddToDoView()
                    .presentationDetents([.large])
            }
        } detail: {
            
            if let item = selectedItem {
                // Wenn ein Item angeklickt wurde -> Bearbeiten-Ansicht
                EditToDoView(toDo: item)
            } else {
                Text("Wähle eine Aufgabe aus")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
