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
    
    func fetchMarketChart(id: String, daysBack: Int, completion: @escaping () -> Void) {
        let toTimestamp = Int(Date().timeIntervalSince1970)
        let fromTimestamp = toTimestamp - (daysBack * 86400)
        
        service.getHistoryChart(id: id, from: fromTimestamp, to: toTimestamp) { result in
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
