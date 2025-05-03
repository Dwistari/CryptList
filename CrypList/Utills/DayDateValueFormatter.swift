//
//  DayDateValueFormatter.swift
//  CrypList
//
//  Created by Dwistari on 03/05/25.
//

import UIKit
import DGCharts

class DateValueFormatter: AxisValueFormatter {
    private let dateFormatter: DateFormatter

    init(dateFormat: String = "dd/MM/yy") {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}
