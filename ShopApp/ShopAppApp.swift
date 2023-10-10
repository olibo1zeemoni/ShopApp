//
//  ShopAppApp.swift
//  ShopApp
//
//  Created by Olibo moni on 09/10/2023.
//

import SwiftUI
import GRDB

@main
struct ShopAppApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView(products: $dataController.products)
                .task {
                    do {
                      try await  dataController.loadAllData()
                    } catch {
                        print(error.localizedDescription)
                    }
                }

        }
    }
}
