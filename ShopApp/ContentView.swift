//
//  ContentView.swift
//  ShopApp
//
//  Created by Olibo moni on 10/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var products: [Product]
    @State private var isPresentingNewProduct = false 
    @Binding var newProduct: Product
    var addNew: ()->Void
    var reloadProducts: ()->Void
    
    var body: some View {
        NavigationStack {
            List {
                Section("Products") {
                    ForEach(products){ product in
                        HStack{
                            Text(product.title)
                            Spacer()
                            Text(formatPrice(product.price))
                        }
                    }
                }
                
                Section("Controls") {
                    Button("Add") {
                        isPresentingNewProduct = true
                    }
                    Button("Reload") {
                        reloadProducts()
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Store")
            .sheet(isPresented: $isPresentingNewProduct) {
                AddProductView(product: $newProduct) {
                    addNew()
                }
            }
        }
    }
    
    private func formatPrice(_ value: Double) -> String {
        
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "GH¢"
            
            if let formattedValue = formatter.string(from: NSNumber(value: value)) {
                return formattedValue
            } else {
                return "Invalid Price"
            }
        }
}

//#Preview {
//    ContentView()
//}
