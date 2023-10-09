//
//  DataController.swift
//  ShopApp
//
//  Created by Olibo moni on 09/10/2023.
//

import Foundation
import GRDB
import SwiftUI


class DataController {
    private var dbQueue: DatabaseQueue?
     var products = [Product]()
    
    
     init()  {
//         let task = Task<DatabaseQueue, Error> {
//             return try getDatabaseQueue()
//         }
//         let dbQueue = try await task.value
//         self.dbQueue = dbQueue
         self.dbQueue = try? getDatabaseQueue()
    }
    
    private func getDatabaseQueue() throws -> DatabaseQueue {
        let fileManager = FileManager.default
        
        // getting a path to the the DB in "Application Support Directory"
        let dbPath = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(path: "shop.db").path(percentEncoded: true)
        if !fileManager.fileExists(atPath: dbPath) {
            // getting a path to the source DB file
            let dbResourcePath = Bundle.main.path(forResource: "shop", ofType: "db")!
            // copying the DB file into dbPath
            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
        }
        return try DatabaseQueue(path: dbPath)
    }
    
     func loadAllData() {
        products = []
        
        try? dbQueue?.read { db in
            let rows = try Row.fetchAll(db, sql: "SELECT p_title, p_price, p_quantity FROM Product ORDER BY p_id")
            
            for row in rows {
                products.append(Product(id: row[0], title: row[1], price: row[2], quantity: row[3]))
                
            }
        }
         print(products.last ?? "no item")
        
    }
    
     func select1Query() {
        products = []
        
        try? dbQueue?.read { db in
            let row = try Row.fetchOne(db, sql: "SELECT p_id, p_title, p_price, p_quantity FROM Product WHERE p_id = 3")!
            
            products.append(Product(id: row[0], title: row[1], price: row[2], quantity: row[3]))
        }
        
    }
    
     func select2Query() {
        products = []
        
        try? dbQueue?.read { db in
            let rows = try Row.fetchAll(db, sql: "SELECT p_id, p_title, p_price, p_quantity FROM Product WHERE p_price < 3")
            
            for row in rows {
                products.append(Product(id: row[0], title: row[1], price: row[2], quantity: row[3]))
            }
        }
        
    }
    
    func insertObject(title: String, price: Double, quantity: Int) {
        try? dbQueue?.write { db in
            try db.execute(sql: "INSERT INTO Product (p_id, p_title, p_price, p_quantity) VALUES (?, ?, ?)", arguments: [0010, title, price, quantity])
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
