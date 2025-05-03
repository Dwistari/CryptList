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
        service.getMarketChart(id: id, days: days) { result in
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
