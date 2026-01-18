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
                
                Picker("Wähle eine Kategorie", selection: $toDo.category) {
                    // Option "Keine" (falls dein category optional ist)
                    Text("Keine").tag(nil as Category?)
                    
                    // Deine Kategorien aus dem Enum
                    ForEach(Category.allCases) { category in
                        Text(category.title).tag(category as Category?)
                    }
                }
                .pickerStyle(.menu)
            }
            
            DateAndTimeElement(toDo: toDo, sectionHeadline: "Datum & Uhrzeit")
            
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
            
            
            Section("Notizen"){
                TextEditor(text: $toDo.notes).frame(minWidth: 120)
                
                if toDo.notes.isEmpty {
                    Text("Hier kannst du Notizen hinzufügen...").foregroundStyle(.secondary).font(.caption)
                }
            }
            
            AttachmentElement(todo: toDo)
            
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
        .onChange(of: toDo.dueDate) { updateNotification() }
        .onChange(of: toDo.hasDueDate) { updateNotification() }
        .onChange(of: toDo.hasAnyTime) { updateNotification() }
        .onChange(of: toDo.title) { updateNotification() }
        .onChange(of: toDo.isCompleted) {
            // Wenn erledigt, brechen wir sofort ab, sonst Update
            if toDo.isCompleted {
                NotificationManager.instance.cancelNotification(for: toDo)
            } else {
                updateNotification()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Fertig") {
                    dismiss()
                }
                .disabled(toDo.title.isEmpty)
            }
        }
    }
    
    private func updateNotification(){
        NotificationManager.instance.scheduleNotification(for: toDo)
    }
}
