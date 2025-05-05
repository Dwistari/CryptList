//
//  DetailCoinViewController.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import UIKit

class DetailCoinViewController: BaseViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var coin: Coin

    init(coin: Coin) {
        self.coin = coin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        guard let data = coin else {return}
        coinName.text = data.name
        priceLbl.text = String(data.currentPrice) + " USD"
        id = data.id
        let url = URL(string: data.image ?? "")
        logoImg.sd_setImage(with: url,placeholderImage: UIImage(systemName: "photo"), options: [.retryFailed, .continueInBackground])
        
        segmentControl.selectedSegmentIndex = 0
        segmentChanged(segmentControl)
    }
    
    private func configureUI() {
        coinName.text = coin.name
        priceLbl.text = formatPrice(coin.currentPrice)        
        let url = URL(string: coin.image ?? "")
        logoImg.sd_setImage(with: url,placeholderImage: UIImage(systemName: "photo"), options: [.retryFailed, .continueInBackground])
    }
    
    
      private func formatPrice(_ value: Double) -> String {
          let formatter = NumberFormatter()
          formatter.numberStyle = .currency
          formatter.currencySymbol = "USD"
          formatter.maximumFractionDigits = 2
          return formatter.string(from: NSNumber(value: value)) ?? "\(value) USD"
      }
        
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showHistoryView()
        } else {
            showChartView()
        }
        
    }
    
    func showHistoryView() {
        let view = HistoryView.instantiateFromNib()
        view.configure(idCoin: coin.id)
        showView(view)
    }
    
    private func showChartView() {
        let view = ChartView(idCoin: coin.id)
        showView(view)
    }
    
    private func showView(_ view: UIView) {
         containerView.subviews.forEach { $0.removeFromSuperview() }
         view.frame = containerView.bounds
         view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         containerView.addSubview(view)
     }
    
}
