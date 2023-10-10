//
//  LocalDatabase.swift
//  ShopApp
//
//  Created by Olibo moni on 09/10/2023.
//

import Foundation
import GRDB

struct LocalDatabase {

    private let writer: DatabaseWriter

    init(_ writer: DatabaseWriter) throws {
        self.writer = writer
        try migrator.migrate(writer)
    }

    var reader: DatabaseReader {
        writer
    }
}

extension LocalDatabase {
    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif

        migrator.registerMigration("v1") { db in
            try createRestaurantAndDishTables(db)
        }

        return migrator

    }

    private func createRestaurantAndDishTables(_ db: GRDB.Database) throws {
        try db.create(table: "store") { table in
            table.column("id", .integer).primaryKey()
            table.column("title", .text).notNull()
            table.column("price", .double)
            table.column("quantity", .integer)
        }

    }
}
///Persistence
extension LocalDatabase {

    static let shared = makeShared()

    static func makeShared() -> LocalDatabase {
        do {

            let fileManager = FileManager()

            let folder = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("database", isDirectory: true)

            try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)

            let databaseUrl = folder.appendingPathComponent("db.sqlite")

            let writer = try DatabasePool(path: databaseUrl.path)

            let database = try LocalDatabase(writer)

            return database

        } catch {
            fatalError("ERROR: \(error)")
        }


    }
}
