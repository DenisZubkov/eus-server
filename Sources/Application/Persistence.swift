//
//  Persistence.swift
//  Application
//
//  Created by Denis Zubkov on 05/09/2019.
//

import SwiftKueryORM
import SwiftKueryPostgreSQL

class Persistence {
    static func setUp() {
        let pool = PostgreSQLConnection.createPool(
            host: "localhost",
            port: 5432,
            options: [.databaseName("epicus")],
            poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50))
        Database.default = Database(pool)
    }
}
