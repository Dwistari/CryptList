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
    func fetchCoinHistory(page: Int, completion: @escaping  (Result<[CoinCategory], AFError>) -> Void)
    func getCoinChart(completion: @escaping ([Coin]) -> Void)
    func getHistoryChart(id: String, from: Int, to: Int, completion: @escaping  (Result<MarketChartRangeResponse, AFError>) -> Void)
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
            print("url---",  APIEndpoints.Coins.category)
            print("result", result)
            completion(result)
        }
    }
    
    func fetchCoinHistory(page: Int, completion: @escaping  (Result<[CoinCategory], AFError>) -> Void) {
        NetworkManager.shared.request(url: APIEndpoints.Coins.history(id: "", date: "")) { (result: Result<[CoinCategory], AFError>) in
            completion(result)
        }
    }
    
    
    func getCoinChart(completion: @escaping ([Coin]) -> Void) {
        
    }
    
    func getHistoryChart(id: String, from: Int, to: Int, completion: @escaping  (Result<MarketChartRangeResponse, AFError>) -> Void) {
        let params: [String: Any] = [
               "vs_currency": "usd",
               "from": from,
               "to": to
           ]
        NetworkManager.shared.request(url: APIEndpoints.Coins.marketChartRange(id: id), parameters: params) { (result: Result<MarketChartRangeResponse, AFError>) in
            print("✅ Final URL: \(APIEndpoints.Coins.marketChartRange(id: id))")
            print("✅ Params: \(params)")
            
            print("from", from)
            print("to", to)
            
            print("✅ result: \(result)")

            completion(result)
        }
    }
    
}
