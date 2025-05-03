//
//  HistoryView.swift
//  CrypList
//
//  Created by Dwistari on 02/05/25.
//

import UIKit

class HistoryView: UIView {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var markerLbl: UILabel!
    @IBOutlet weak var volumeLbl: UILabel!
    @IBOutlet weak var changeLbl: UILabel!
    
    var idCoin: String = ""
    
    static func instantiateFromNib() -> HistoryView {
        let nib = UINib(nibName: "HistoryView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! HistoryView
    }
    
    
    var viewModel: HistoryViewModel = {
        let viewModel = HistoryViewModel(service: APIService())
        return viewModel
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(idCoin: String) {
        self.idCoin = idCoin
        fetchHistory(date: getDate(date: datePicker.date))
    }
    
    private func setupView() {
        datePicker.maximumDate = Date() 
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        fetchHistory(date: getDate(date: selectedDate))
    }
    
    func fetchHistory(date: String) {
        viewModel.fetchHistorycalData(id: idCoin, date: date) { [weak self] in
            guard let self = self else { return }
            if !self.viewModel.errorMsg.isEmpty {
                self.showToast(message: self.viewModel.errorMsg)
                return
            }
            guard let data = self.viewModel.history else { return }
            self.bindView(data: data)
        }
    }
    
    private func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    private func bindView(data: CoinHistory) {
        if let price = data.marketData?.currentPrice["usd"] {
            priceLbl.text = String(format: "%.2f", price)
        }
        
        if let marketCap = data.marketData?.marketCap["usd"] {
            markerLbl.text = String(format: "%.2f", marketCap)
        }
        
        if let volume = data.marketData?.totalVolume["usd"] {
            volumeLbl.text = String(format: "%.2f", volume)
        }
    }
    
}

