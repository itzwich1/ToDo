//
//  AddToDoView.swift
//  ToDo
//
//  Created by Felix Wich on 09.01.26.
//

import SwiftUI
import SwiftData

struct AddToDoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Lokale Variablen (Temp-Speicher)
    @State private var title: String = ""
    @State private var priority: Priority = .medium
    @State private var isCompleted: Bool = false
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Neue Aufgabe") {
                    TextField("Titel", text: $title)
                    Toggle("Erledigt", isOn: $isCompleted)
                }
                
                Section("Wichtigkeit") {
                    Picker("Priorität", selection: $priority) {
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
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                    if notes.isEmpty {
                        Text("Notizen hinzufügen...").foregroundStyle(.secondary)
                    }
                }
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
                    .disabled(title.isEmpty) // Schutz gegen leere Aufgaben
                }
            }
        }
    }
    
    private func saveItem() {
        // 1. Objekt aus den lokalen Variablen bauen
        let newItem = ToDoModel(
            timestamp: Date(),
            title: title,
            isCompleted: isCompleted,
            notes: notes,
            priority: priority
        )
        
        // 2. In die Datenbank werfen
        modelContext.insert(newItem)
        
        // 3. Fenster zu
        dismiss()
    }
}
