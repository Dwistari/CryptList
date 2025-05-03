//
//  ChartView.swift
//  CrypList
//
//  Created by Dwistari on 02/05/25.
//

import UIKit
import Charts
import DGCharts

class ChartView: UIView {
    
    var idCoin: String = ""
    
    private var segmentControl: UISegmentedControl = {
        let segmentControl =  UISegmentedControl(items: ["1D", "7D", "1M", "3M", "1Y"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private var lineChartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(idCoin: String) {
        self.idCoin = idCoin
        super.init(frame: .zero)
        setupView()
    }
    
    
    var viewModel: ChartViewModel = {
        let viewModel = ChartViewModel(service: APIService())
        return viewModel
    }()
    
    
    private func setupView() {
        addSubview(segmentControl)
        addSubview(lineChartView)
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant:40),

            lineChartView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            lineChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            lineChartView.heightAnchor.constraint(equalToConstant: 500)
            
        ])
        setupSegment()
    }
    
    func setupSegment() {
        segmentControl.setTitle("1D", forSegmentAt: 0)
        segmentControl.setTitle("7D", forSegmentAt: 1)
        segmentControl.setTitle("1M", forSegmentAt: 2)
        segmentControl.setTitle("3M", forSegmentAt: 3)
        segmentControl.setTitle("1Y", forSegmentAt: 4)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        fetchChart(days: 1)
    }
    
    func configure(with dataPoints: [(timestamp: Double, price: Double)]) {
        
        let entries = dataPoints.map { ChartDataEntry(x: $0.timestamp, y: $0.price) }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Price")
        dataSet.colors = [.systemBlue]
        dataSet.circleColors = [.systemBlue]
        dataSet.circleRadius = 3
        dataSet.drawValuesEnabled = false
        
        let lineData = LineChartData(dataSet: dataSet)
        lineChartView.xAxis.valueFormatter = DateValueFormatter()
        lineChartView.data = lineData
        lineChartView.xAxis.labelRotationAngle = -45
        lineChartView.xAxis.granularity = 86400
        lineChartView.xAxis.setLabelCount(5, force: false)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.animate(xAxisDuration: 1.0)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            fetchChart(days: 1)
        case 1:
            fetchChart(days: 7)
        case 2:
            fetchChart(days: 30)
        case 3:
            fetchChart(days: 90)
        case 4:
            fetchChart(days: 365)
        default:
            break
        }
    }
    
    func fetchChart(days: Int) {
        viewModel.fetchMarketChart(id: idCoin, daysBack: days) { [weak self] in
            guard let chart = self?.viewModel.chart else {return}
            let chartData: [[Double]] = chart.prices
            let dataPoints: [(timestamp: Double, price: Double)] = chartData.compactMap {
                guard $0.count == 2 else { return nil }
                return (timestamp: $0[0], price: $0[1])
            }

            self?.configure(with: dataPoints)
        }
    }
    
}
