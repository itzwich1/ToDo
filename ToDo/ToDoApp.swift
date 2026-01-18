//
//  ToDoApp.swift
//  ToDo
//
//  Created by Felix Wich on 08.01.26.
//

import SwiftUI
import SwiftData

@main
struct ToDoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            ToDoModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        // Hier fragen wir direkt beim Start (oder du machst es erst beim ersten ToDo)
        NotificationManager.instance.requestAuthorization()
    }
    
    var body: some Scene {
        
        
        
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
