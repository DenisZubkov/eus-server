//
//  ODataQuery.swift
//  Application
//
//  Created by Denis Zubkov on 06/09/2019.
//

import Foundation

struct ODataQuery {
    var server: ODataServer
    var table: String
    var filter: String?
    var select: String?
    var orderBy: String?
    var id: Int?
}

enum QueryResultFormat: String {
    case json = "json"
    case xml = "xml"
    case tfs = "3.2"
}
