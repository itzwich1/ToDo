//
//  EditToDoView.swift
//  ToDo
//
//  Created by Felix Wich on 09.01.26.
//

import SwiftUI
import SwiftData

struct EditToDoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var toDo: ToDoModel
    
    var body: some View {
        
        Form{
            
            // Titel und Status
            Section("Aufgabe"){
                TextField("Title eingeben", text: $toDo.title)
                
                
                
                Toggle("Erledigt", isOn: $toDo.isCompleted)
            }
            
            Section("Datum & Uhrzeit"){
                
                HStack{
                    Image(systemName: "calendar").foregroundStyle(.red)
                }
            }
            
            // Prioritaet
            Section("Wichtigkeit"){
                Picker("Priorität", selection: $toDo.priority) {
                    ForEach(Priority.allCases) { priority in
                        HStack {
                            Text(priority.title)
                        }
                        .foregroundStyle(priority.color)
                        .tag(priority)
                    }
                }
            }
            
            
            Section("Details"){
                TextEditor(text: $toDo.notes).frame(minWidth: 120)
                
                if toDo.notes.isEmpty {
                    Text("Hier kannst du Notizen hinzufügen...").foregroundStyle(.secondary).font(.caption)
                }
            }
            
            Section{
                HStack {
                    Text("Erstellt am:")
                    Spacer()
                    Text(toDo.timestamp.formatted(date: .numeric, time: .shortened))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Bearbeiten")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            
            ToolbarItem(placement: .confirmationAction) {
                // Button heißt "Fertig", weil gespeichert wird automatisch
                Button("Fertig") {
                    // Da @Bindable die Daten schon live geschrieben hat,
                    // müssen wir hier nur das Fenster zumachen.
                    dismiss()
                }
                // HIER WAR DER FEHLER: Du musst toDo.title prüfen, nicht title
                .disabled(toDo.title.isEmpty)
            }
        }
        
        
    }
}
