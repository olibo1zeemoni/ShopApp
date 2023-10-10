//
//  AddProductView.swift
//  ShopApp
//
//  Created by Olibo moni on 10/10/2023.
//

import SwiftUI

struct AddProductView: View {
    @Binding var product: Product
    @Environment(\.dismiss) var dismiss
    var createButtonAction: ()->Void
    
    var body: some View {
        VStack(spacing: 15) {
            
            Form {
                Section("Create New Product") {
//                    TextField("Id", value: $product.id, formatter: NumberFormatter())
                    TextField("Title", text: $product.title)
                    TextField("Quantity", value: $product.quantity, formatter: NumberFormatter())
                    TextField("Price", value: $product.price, formatter: currencyFormatter)
                    
                }
            }
            .formStyle(.grouped)
            
            
            Button {
                createButtonAction()
//                Task {
//                    //await viewModel.createRestaurant()
//                }
                dismiss()
            } label: {
                HStack {
                    Spacer()
                    Text("Create")
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                    Spacer()
                }
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            Spacer()
            }
        .toolbar {
            Button("Cancel") {
                dismiss()
            }
        }
        
    }
    
    private let currencyFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_GH") // Set your desired locale
            
            return formatter
        }()
}

#Preview {
    AddProductView(product: .constant(Product(title: "milk", price: 20, quantity: 5)), createButtonAction: {})
}
