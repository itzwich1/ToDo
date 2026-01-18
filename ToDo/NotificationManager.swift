//
//  NotificationManager.swift
//  ToDo
//
//  Created by Felix Wich on 17.01.26.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    //Singleton (zugriff von ueberall)
    static let instance = NotificationManager()
    
    //Berechtigungen abfragen
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            
            if let error = error {
                print("Fehler: \(error.localizedDescription)")
            } else {
                print("Erlaubnis erteilt: \(success)")
            }
            
        }
    }
    
    func scheduleNotification(for todo: ToDoModel){
        // Nur planen, wenn auch ein Datum gesetzt ist
        guard todo.hasDueDate else { return }
        
        // Inhalt der Nachricht
        let content = UNMutableNotificationContent()
        
        
        
        //Eindeutige ID des ToDo's
        let identifier = todo.id.uuidString
        
        var components: DateComponents
        
        if todo.hasAnyTime {
            
            //Erinnerung zur entsprechenden Uhrzeit
            if let reminderDate = Calendar.current.date(byAdding: .minute, value: -60, to: todo.dueDate) {
                // Und holen uns DANN die Komponenten von diesem neuen Datum
                components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
            } else {
                // Fallback (sollte nie passieren)
                components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: todo.dueDate)
            }
            
            content.title = "ToDo: \"\(todo.title)\" in 1h fällig!"
            
        } else {
            
            //Erinnerung bei ganzaegigen Events
            components = Calendar.current.dateComponents([.year, .month, .day], from: todo.dueDate)
            
            content.title = "ToDo: \(todo.title) heute fällig!"
            
            components.hour = 6
            components.minute = 0
        }
        
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Anfrage erstellen
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Anfrage an das System übergeben
        UNUserNotificationCenter.current().add(request)
        print("Benachrichtigung geplant für: \(todo.title) um \(todo.dueDate)")
    }
    
    
    func cancelNotification(for todo: ToDoModel){
        let identifier = todo.title
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
