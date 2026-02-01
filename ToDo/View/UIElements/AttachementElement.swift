//
//  AttachementSectionView.swift
//  ToDo
//
//  Created by Felix Wich on 15.01.26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct AttachmentElement: View {
    
    @Bindable var todo: ToDoModel
    
    @State private var showFileImporter: Bool = false
    
    var body: some View {
        Section("Anhang") {
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
                Button(action: { showFileImporter = true }) {
                    Label("Datei hinzufügen", systemImage: "paperclip")
                }
            }
        }
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
