//
//  QuotasJSON.swift
//  Application
//
//  Created by Denis Zubkov on 06/09/2019.
//

import Foundation

struct QuotasJSON: Codable {
    let odataMetadata: String
    let value: [Value]
    
    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    struct Value: Codable {
        let quart: String
        let directionId: String
        let storePointAnaliticPlan: Double
        let storePointAnaliticWork: Double
        let storePointAnaliticFact: Double
        let storePointDevPlan: Double
        let storePointDevWork: Double
        let storePointDevFact: Double
        
        enum CodingKeys: String, CodingKey {
            case quart = "Period"
            case directionId = "НаправлениеРазвитияПО_Key"
            case storePointAnaliticPlan = "ТрудозатратыОАПлан"
            case storePointAnaliticWork = "ОАВзятоВРаботу"
            case storePointAnaliticFact = "ТрудозатратыОАФакт"
            case storePointDevPlan = "ТрудозатратыОРПОПлан"
            case storePointDevWork = "ОРПОВзятоВРаботу"
            case storePointDevFact = "ТрудозатратыОРПОФакт"
        }
    }
    
}
