//
//  ChartViewModel.swift
//  CrypList
//
//  Created by Dwistari on 02/05/25.
//

import Foundation

class ChartViewModel {
    
    var service: CoinServiceProtocol
    var chart: MarketChartRangeResponse?
    var errorMsg: String = ""
    
    init(service: CoinServiceProtocol) {
        self.service = service
    }
    
    func fetchMarketChart(id: String, days: Int, completion: @escaping () -> Void) {
        service.getMarketChart(id: id, days: days){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let chart):
                self.chart = chart
                completion()
            case .failure(let error):
                self.errorMsg = error.localizedDescription
                completion()
            }
        }
    }
    
    func fetchChartRange(id: String, from: Int, to: Int, completion: @escaping () -> Void) {
        service.getChartRange(id: id, from: from, to: to ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let chart):
                self.chart = chart
                completion()
            case .failure(let error):
                self.errorMsg = error.localizedDescription
                completion()
            }
        }
    }
}
