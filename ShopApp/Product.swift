//
//  Product.swift
//  ShopApp
//
//  Created by Olibo moni on 09/10/2023.
//

import Foundation


struct Product: Identifiable {
    var id = UUID()
    var title: String
    var price: Double
    var quantity: Int
}
