//
//  AddToDoView.swift
//  ToDo
//
//  Created by Felix Wich on 09.01.26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct AddToDoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var newToDo = ToDoModel(timestamp: Date())
    
    @State private var showFileImporter: Bool = false
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section("Neue Aufgabe") {
                    TextField("Titel", text: $newToDo.title)
                    Toggle("Erledigt", isOn: $newToDo.isCompleted)
                    
                    Picker("Wähle eine Kategorie", selection: $newToDo.category) {
                        // Option "Keine" (falls dein category optional ist)
                        Text("Keine").tag(nil as Category?)
                        
                        // Deine Kategorien aus dem Enum
                        ForEach(Category.allCases) { category in
                            Text(category.title).tag(category as Category?)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    
                }
                
                DateAndTimeElement(toDo: newToDo,sectionHeadline: "Datum & Uhrzeit")
                
                Section("Wichtigkeit") {
                    Picker("Priorität", selection: $newToDo.priority) {
                        ForEach(Priority.allCases) { priority in
                            HStack {
                                Text(priority.title)
                            }
                            .foregroundStyle(priority.color)
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Notizen") {
                    TextEditor(text: $newToDo.notes)
                        .frame(minHeight: 100)
                    if newToDo.notes.isEmpty {
                        Text("Notizen hinzufügen...").foregroundStyle(.secondary)
                    }
                }
                
                AttachmentElement(todo: newToDo)
                
            }
            .navigationTitle("Neues ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ABBRECHEN: Einfach schließen, NICHTS wird gespeichert
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                
                // SPEICHERN: Jetzt erst wird das Objekt erstellt
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        saveItem()
                    }
                    .disabled(newToDo.title.isEmpty) // Schutz gegen leere Aufgaben
                }
            }
        }
    }
    
    private func saveItem() {
        print(newToDo.priority.title)
        modelContext.insert(newToDo)
        
        NotificationManager.instance.scheduleNotification(for: newToDo)
        
        dismiss()
    }
}
