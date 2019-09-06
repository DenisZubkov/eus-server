//
//  Quota.swift
//  Application
//
//  Created by Denis Zubkov on 06/09/2019.
//

import SwiftKueryORM

struct Quota: Codable {
    public var id: Int?
    public var quart: String
    public var storePointAnaliticPlan: Double
    public var storePointAnaliticFact: Double
    public var storePointAnaliticWork: Double
    public var storePointDevPlan: Double
    public var storePointDevFact: Double
    public var storePointDevWork: Double
    public var directionId: String
}

extension Quota: Equatable {
    public static func ==(lhs: Quota, rhs: Quota) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Quota: Model {}
