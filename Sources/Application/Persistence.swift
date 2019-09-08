//
//  Persistence.swift
//  Application
//
//  Created by Denis Zubkov on 05/09/2019.
//

import Foundation
import SwiftKueryORM
import SwiftKueryPostgreSQL

class Persistence {
    static func setUp() {
        let pool = PostgreSQLConnection.createPool(
            host: "postgresql-database",
            port: 5432,
            options: [
                .databaseName("epicus"),
                .userName("postgres"),
                .password(ProcessInfo.processInfo.environment["DBPASSWORD"] ?? "nil"),
            ],
            poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50))
        Database.default = Database(pool)
    }
}
