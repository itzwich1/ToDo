//
//  DateAndTimeElement.swift
//  ToDo
//
//  Created by Felix Wich on 15.01.26.
//

import SwiftUI
import SwiftData


struct DateAndTimeElement: View {
    
    @Bindable var toDo: ToDoModel
    
    var sectionHeadline: String = ""
    
    var body: some View {
        Section(sectionHeadline){
            
            HStack{
                // Linke Seite: Icon und Text
                Image(systemName: "calendar")
                Text("Datum")
                
                Spacer()
                
                if toDo.hasDueDate {
                    DatePicker("", selection: $toDo.dueDate, displayedComponents: [.date])
                        .labelsHidden()
                        .datePickerStyle(.compact)
                }
                
                Toggle("", isOn: $toDo.hasDueDate)
                    .labelsHidden()
            }
            
            HStack{
                // Linke Seite: Icon und Text
                Image(systemName: "clock")
                Text("Uhrzeit")
                
                Spacer()
                
                if toDo.hasAnyTime {
                    DatePicker("", selection: $toDo.dueDate, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                        .datePickerStyle(.compact)
                }
                
                Toggle("", isOn: $toDo.hasAnyTime)
                    .labelsHidden()
            }
        }
    }
}
