//
//  ContentView.swift
//  ShopApp
//
//  Created by Olibo moni on 09/10/2023.
//

import SwiftUI
import GRDB

struct ProductsListView: View {
    
    @StateObject var productViewModel = ProductViewModel()
    @State private var isPresentingSheet = false
    @State var newProduct = ProductViewModel.emptyProduct
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("Products") {
                    ForEach(productViewModel.products){ product in
                        HStack{
                            Text(product.title)
                            Spacer()
                            Text(formatPrice(product.price))
                        }
                    }
                }
                
                Section("Controls") {
                    Button("load all") {
                        //dataController.loadAllData()
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                Button {
                    isPresentingSheet = true
                } label: {
                    Image(systemName: "plus")
                }

            }
            .sheet(isPresented: $isPresentingSheet) {
                NavigationStack{
                    AddProductView(product: $newProduct, createButtonAction: {
                        productViewModel.products.append(newProduct)
                        newProduct = ProductViewModel.emptyProduct
                    })
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

#Preview {
    
    ProductsListView()
        
}
