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
                
                //Erledigt Section
                FinishedToDoElement(items: items)
                
            }.navigationTitle("ToDo's")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: { showAddSheet = true }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) { // .topBarLeading bei neuerem iOS
                        Menu {
                            /*Picker("Filter") {
                                ForEach(FilterOption.allCases) { filter in
                                    // Zeigt Haken beim ausgewählten Element an
                                    Label(filter.rawValue, systemImage: iconForFilter(filter))
                                        .tag(filter)
                                }
                            }*/
                        } label: {
                            // Das Icon in der Toolbar (Ein Filter-Trichter im Kreis)
                            Image(systemName: "line.3.horizontal.decrease")
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
