//
//  ContentView.swift
//  ShopApp
//
//  Created by Olibo moni on 09/10/2023.
//

import SwiftUI
import GRDB

struct ContentView: View {
    var dataController = DataController()
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("Products") {
                    ForEach(dataController.products){ product in
                        HStack{
                            Text(product.title)
                        }
                    }
                }
                
                Section("Controls") {
                    Button("load all") {
                        dataController.loadAllData()
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .onAppear {
                //Task {
                     dataController.loadAllData()
                //}
            }
        }
    }
}

//#Preview {
//    ContentView()
//        
//}
