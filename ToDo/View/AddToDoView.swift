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
                }
                
                Section("Datum & Uhrzeit"){
                    
                    HStack{
                        // Linke Seite: Icon und Text
                        Image(systemName: "calendar")
                        Text("Datum")
                        
                        Spacer()
                        
                        if newToDo.hasDueDate {
                            DatePicker("", selection: $newToDo.dueDate, displayedComponents: [.date])
                                .labelsHidden()
                                .datePickerStyle(.compact)
                        }
                        
                        Toggle("", isOn: $newToDo.hasDueDate)
                            .labelsHidden()
                    }
                    
                    HStack{
                        // Linke Seite: Icon und Text
                        Image(systemName: "clock")
                        Text("Uhrzeit")
                        
                        Spacer()
                        
                        if newToDo.hasAnyTime {
                            DatePicker("", selection: $newToDo.dueDate, displayedComponents: [.hourAndMinute])
                                .labelsHidden()
                                .datePickerStyle(.compact)
                        }
                        
                        Toggle("", isOn: $newToDo.hasAnyTime)
                            .labelsHidden()
                    }
                }
                
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
                
                
                ///
                Section("Anhang") {
                    // Wenn schon eine Datei da ist, zeigen wir den Namen und einen Löschen-Button
                    if let name = newToDo.attachmentName {
                        HStack {
                            Image(systemName: "doc.fill")
                                .foregroundStyle(.blue)
                            Text(name)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            
                            Spacer()
                            
                            // Button zum Entfernen des Anhangs
                            Button(role: .destructive) {
                                withAnimation {
                                    newToDo.attachment = nil
                                    newToDo.attachmentName = nil
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                        }
                    } else {
                        // Wenn noch keine Datei da ist -> Button zum Hinzufügen
                        Button(action: { showFileImporter = true }) {
                            Label("Datei hinzufügen", systemImage: "paperclip")
                        }
                    }
                }.fileImporter(
                    isPresented: $showFileImporter,
                    allowedContentTypes: [.item], // .item erlaubt ALLES (Bilder, PDFs, Text...)
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let urls):
                        if let url = urls.first {
                            // WICHTIG: Sicherheitshalber Zugriff anfordern (Sandboxing)
                            if url.startAccessingSecurityScopedResource() {
                                defer { url.stopAccessingSecurityScopedResource() }
                                
                                do {
                                    // 1. Die Datei in Daten (Bytes) umwandeln
                                    let fileData = try Data(contentsOf: url)
                                    
                                    // 2. Ins Model speichern
                                    newToDo.attachment = fileData
                                    newToDo.attachmentName = url.lastPathComponent // z.B. "Foto.jpg"
                                } catch {
                                    print("Fehler beim Laden der Datei: \(error.localizedDescription)")
                                }
                            }
                        }
                    case .failure(let error):
                        print("Abbruch oder Fehler: \(error.localizedDescription)")
                    }
                }
                
                ///
                
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
        // 1. Objekt aus den lokalen Variablen bauen
        /*let newItem = ToDoModel(
         timestamp: Date(),
         title: title,
         isCompleted: isCompleted,
         notes: notes,
         priority: priority,
         dueDate: dueDate,
         hasDueDate: hasDueDate
         )*/
        
        print(newToDo.priority.title)
        // 2. In die Datenbank werfen
        modelContext.insert(newToDo)
        
        // 3. Fenster zu
        dismiss()
    }
}
