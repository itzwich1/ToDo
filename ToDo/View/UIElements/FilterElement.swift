//
//  FilterElement.swift
//  ToDo
//
//  Created by Felix Wich on 16.01.26.
//

import SwiftData
import SwiftUI

struct FilterElement: View {
    
    @Binding var filteredCategory: Category?
    
    var body: some View {
        
        // .topBarLeading bei neuerem iOS
        Menu {
            Picker("Kategorie", selection: $filteredCategory){
                Text("Alle anzeigen").tag(nil as Category?)
                
                ForEach(Category.allCases) { category in
                    // Label zeigt Text + Icon (falls du Icons im Enum hast)
                    Text(category.title).tag(category as Category?)
                }
                
            }
            
        } label: {
            // Das Icon in der Toolbar (Ein Filter-Trichter im Kreis)
            Image(systemName: filteredCategory == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
        }
        
        
        
    }
}
