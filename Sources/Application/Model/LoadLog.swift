//
//  LoadLog.swift
//  Application
//
//  Created by Denis Zubkov on 06/09/2019.
//

import SwiftKueryORM

struct LoadLog: Codable {
    public var id: Int?
    public var date: String?
    public var name: String?
    public var description: String?
    public var Value: Int?
    public var time: Double?
}

extension LoadLog: Model {}
