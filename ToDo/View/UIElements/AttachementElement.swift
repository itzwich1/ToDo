//
//  AttachementSectionView.swift
//  ToDo
//
//  Created by Felix Wich on 15.01.26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers // WICHTIG für .item

struct AttachmentElement: View {
    // Wir empfangen das Model.
    // @Bindable ist hier super, falls wir später z.B. den Dateinamen editierbar machen wollen.
    @Bindable var todo: ToDoModel
    
    // Der State für das Popup gehört jetzt nur noch zu dieser kleinen View
    @State private var showFileImporter: Bool = false
    
    var body: some View {
        Section("Anhang") {
            // 1. Anzeige wenn Datei vorhanden
            if let name = todo.attachmentName {
                HStack {
                    Image(systemName: "doc.fill")
                        .foregroundStyle(.blue)
                    Text(name)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    
                    Spacer()
                    
                    Button(role: .destructive) {
                        withAnimation {
                            todo.attachment = nil
                            todo.attachmentName = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            } else {
                // 2. Button zum Hinzufügen
                Button(action: { showFileImporter = true }) {
                    Label("Datei hinzufügen", systemImage: "paperclip")
                }
            }
        }
        // 3. Der komplexe File-Importer Code ist jetzt hier versteckt
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [UTType.item],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    if url.startAccessingSecurityScopedResource() {
                        defer { url.stopAccessingSecurityScopedResource() }
                        do {
                            let fileData = try Data(contentsOf: url)
                            todo.attachment = fileData
                            todo.attachmentName = url.lastPathComponent
                        } catch {
                            print("Fehler: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("Fehler: \(error.localizedDescription)")
            }
        }
    }
}
