//
//  MarketChartRangeResponse.swift
//  CrypList
//
//  Created by Dwistari on 02/05/25.
//

import Foundation

struct MarketChartRangeResponse: Codable {
    let prices: [[Double]]
    let marketCaps: [[Double]]
    let totalVolumes: [[Double]]
    
    enum CodingKeys: String, CodingKey {
        case prices
        case marketCaps = "market_caps"
        case totalVolumes = "total_volumes"
    }
}
