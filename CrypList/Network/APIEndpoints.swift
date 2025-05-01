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
        static func history(id: String, date: String) -> String {
            return "\(baseURL)/\(id)/history?date=\(date)"
        }
        static func marketChart(id: String, days: String) -> String {
            return "\(baseURL)/\(id)/market_chart?vs_currency=usd&days=\(days)"
        }
        static func marketChartRange(id: String, from: String, to: String) -> String {
            return "\(baseURL)/\(id)/market_chart/range?vs_currency=usd&from=\(from)&to=\(to)"
        }
        
        
    }
}
