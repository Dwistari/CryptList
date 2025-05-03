//
//  CoinHistory.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//


import Foundation

struct CoinHistory: Codable {
    let id: String
    let symbol: String
    let name: String
    let localization: [String: String]
    let image: Image
    let marketData: MarketData?

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case localization
        case image
        case marketData = "market_data"
    }
}

struct Image: Codable {
    let thumb: String
    let small: String
}

struct MarketData: Codable {
    let currentPrice: [String: Double]
    let marketCap: [String: Double]
    let totalVolume: [String: Double]

    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case totalVolume = "total_volume"
    }
}
