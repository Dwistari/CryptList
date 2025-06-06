//
//  APIEndpoints.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import Foundation

struct APIEndpoints {
    static let baseURL = "https://api.coingecko.com/api/v3/coins"

    struct Coins {
        static let list = "\(baseURL)/markets"
        static let category = "\(baseURL)/categories"

        static func details(id: String) -> String {
            return "\(baseURL)/\(id)"
        }
        static func history(id: String) -> String {
            return "\(baseURL)/\(id)/history"
        }
        static func marketChart(id: String) -> String {
            return "\(baseURL)/\(id)/market_chart"
        }
        static func marketChartRange(id: String) -> String {
            return "\(baseURL)/\(id)/market_chart/range"
        }
        
        
    }
}
