//
//  ProductViewModel.swift
//  ShopApp
//
//  Created by Olibo moni on 10/10/2023.
//

import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = [ Product(title: "milk", price: 30.0, quantity: 10), Product(title: "butter", price: 35.0, quantity: 7)]
    
    static var emptyProduct = Product(title: "", price: 0.0, quantity: 0)
    
}
