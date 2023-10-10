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
    @State  var newProduct = Product(title: "", price: 0.0, quantity: 0)
    
    var body: some Scene {
        WindowGroup {
            ContentView(products: $dataController.products, newProduct: $newProduct) {
                do {
                    try dataController.saveObject(product: newProduct)
                    newProduct = Product(title: "", price: 0.0, quantity: 0)
                    
                } catch {
                    print(error.localizedDescription)
                }
            } reloadProducts: {
                Task{
                    do {
                        try await  dataController.loadAllData()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
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
