//
//  DataController.swift
//  ShopApp
//
//  Created by Olibo moni on 09/10/2023.
//

import Foundation
import GRDB
import SwiftUI


@MainActor
class DataController: ObservableObject {
    private var dbQueue: DatabaseQueue?
   @Published var products = [Product]()
    

    
    
    init() {
        
    }
    
    private func getDatabaseQueue() throws -> DatabaseQueue {
        let fileManager = FileManager.default
        
        // getting a path to the the DB in "Application Support Directory"
        let dbPath = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(path: "shop.db").path
        //MARK: percentage encoding
        if !fileManager.fileExists(atPath: dbPath) {
            // getting a path to the source DB file
            let dbResourcePath = Bundle.main.path(forResource: "shop", ofType: "db")!
            // copying the DB file into dbPath
            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
        }
        return try DatabaseQueue(path: dbPath)
    }

    func loadAllData() async throws {
        do {
            let rows = try await withCheckedThrowingContinuation { continuation in
                Task {
                    do {
                        dbQueue = try getDatabaseQueue()
                        let rows = try dbQueue?.read { db in
                            return try Row.fetchAll(db, sql: "SELECT p_title, p_price, p_quantity FROM Product ORDER BY p_title")
                        }
                        continuation.resume(returning: rows)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            if let rows = rows {
                await MainActor.run {
                    self.products = rows.map { row in
                        Product(title: row[0], price: row[1], quantity: row[2])
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    
}
    




extension DataController {
    
     func select1Query() {
        products = []
        
         try? dbQueue?.read { db in
            let row = try Row.fetchOne(db, sql: "SELECT p_title, p_price, p_quantity FROM Product WHERE p_id = 3")!
            
            products.append(Product(title: row[0], price: row[1], quantity: row[2]))
        }
        
    }
    
     func select2Query() {
        products = []
        
         try? dbQueue?.read { db in
            let rows = try Row.fetchAll(db, sql: "SELECT p_title, p_price, p_quantity FROM Product WHERE p_price < 40")
            
            for row in rows {
                products.append(Product(title: row[0], price: row[1], quantity: row[2]))
            }
        }
        
    }
    
    func saveObject(product: Product) throws {
        do{
            try dbQueue?.write { db in
                try db.execute(sql: "INSERT INTO Product (p_id, p_title, p_price, p_quantity) VALUES (?, ?, ?, ?)", arguments: [Int.random(in: 20...100), product.title, product.price, product.quantity])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateProduct(quantity: Int, title: String) {
        try? dbQueue?.write { db in
            try db.execute(sql: "UPDATE Product SET p_quantity = ? WHERE p_title = ?", arguments: [quantity, title])
        }
    }
    
    func deleteProduct(title: String) {
        try? dbQueue?.write { db in
            try db.execute(sql: "DELETE FROM Product WHERE p_title = ?", arguments: [title])
        }
    }
    
}
