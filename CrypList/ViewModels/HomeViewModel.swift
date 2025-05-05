//
//  HomeViewModel.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import Foundation


class HomeViewModel {
    
    var service: CoinServiceProtocol
    var categories: [CoinCategory] = []
    var errorMsg: String = ""
    
    var allCoins: [Coin] = []
    var page: Int = 1
    var limit: Int = 20
    var filter: String = ""
    
    init(service: CoinServiceProtocol) {
        self.service = service
    }
    
    func fetchCoinList(completion: @escaping () -> Void) {
        service.fetchCoinList(page: page, limit: limit, category: filter) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let coins):
                if self.page > 1 {
                    self.allCoins += coins
                } else {
                    self.allCoins = coins
                }
                completion()
            case .failure(let error):
                self.errorMsg = error.localizedDescription
                completion()
            }
        }
    }
    
    func fetchCategoryList(completion: @escaping () -> Void) {
        service.fetchCategory { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let category):
                self.categories = category
                completion()
            case .failure(let error):
                self.errorMsg = error.localizedDescription
                completion()
            }
        }
    }
}
