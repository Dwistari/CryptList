//
//  APIService.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import Foundation
import Alamofire

protocol CoinServiceProtocol {
    func fetchCoinList(page: Int, limit: Int, category: String, completion: @escaping (Result<[Coin], AFError>) -> Void)
    func fetchCategory(completion: @escaping (Result<[CoinCategory], AFError>) -> Void)
    func fetchCoinHistory(id: String, date: String, completion: @escaping  (Result<CoinHistory, AFError>) -> Void)
    func getMarketChart(id: String, days: Int, completion: @escaping  (Result<MarketChartRangeResponse, AFError>) -> Void)
    func getChartRange(id: String, from: Int, to: Int, completion: @escaping  (Result<MarketChartRangeResponse, AFError>) -> Void)
}


class APIService: CoinServiceProtocol {
    
    func fetchCoinList(page: Int, limit: Int, category: String, completion: @escaping (Result<[Coin], AFError>) -> Void) {
        var params: [String: Any] = [:]
        params["vs_currency"] = "usd"
        params["page"] = page
        params["per_page"] = limit
        
        if !category.isEmpty {
            params["category"] = category
        }
        NetworkManager.shared.request(url: APIEndpoints.Coins.list, parameters: params) { (result: Result<[Coin], AFError>) in
            print("url---",  APIEndpoints.Coins.list)
            print("result", result)
            
            completion(result)
        }
    }
    
    func fetchCategory(completion: @escaping (Result<[CoinCategory], AFError>) -> Void) {
        NetworkManager.shared.request(url: APIEndpoints.Coins.category) { (result: Result<[CoinCategory], AFError>) in
            completion(result)
        }
    }
    
    func fetchCoinHistory(id: String, date: String, completion: @escaping  (Result<CoinHistory, AFError>) -> Void) {
        let params: [String: Any] = [
            "vs_currency": "usd",
            "date": date
        ]
        NetworkManager.shared.request(url: APIEndpoints.Coins.history(id: id), parameters: params) { (result: Result<CoinHistory, AFError>) in
            completion(result)
        }
    }
    
    func getMarketChart(id: String, days: Int, completion: @escaping  (Result<MarketChartRangeResponse, AFError>) -> Void) {
        let params: [String: Any] = [
            "vs_currency": "usd",
            "days": String(days),
        ]
        NetworkManager.shared.request(url: APIEndpoints.Coins.marketChart(id: id), parameters: params) { (result: Result<MarketChartRangeResponse, AFError>) in
            completion(result)
        }
    }
    
    func getChartRange(id: String, from: Int, to: Int, completion: @escaping  (Result<MarketChartRangeResponse, AFError>) -> Void) {
        let params: [String: Any] = [
            "vs_currency": "usd",
            "from": from,
            "to": to
        ]
        NetworkManager.shared.request(url: APIEndpoints.Coins.marketChartRange(id: id), parameters: params) { (result: Result<MarketChartRangeResponse, AFError>) in
            completion(result)
        }
    }
    
}
