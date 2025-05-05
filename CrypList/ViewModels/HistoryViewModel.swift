//
//  HistoryViewModel.swift
//  CrypList
//
//  Created by Dwistari on 02/05/25.
//

import Foundation

class HistoryViewModel {
    
    var service: CoinServiceProtocol
    var history: CoinHistory?
    var errorMsg: String = ""
    
    init(service: CoinServiceProtocol) {
        self.service = service
    }
    
    func fetchHistorycalData(id: String, date: String, completion: @escaping () -> Void) {
        service.fetchCoinHistory(id: id, date: date) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.history = response
                completion()
            case .failure(let error):
                self.errorMsg = error.localizedDescription
                completion()
            }
        }
    }
}
