//
//  DetailCoinViewController.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import UIKit

class DetailCoinViewController: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var coin: Coin?
    var id: String = ""

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
        
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showHistoryView()
        } else {
            showChartView()
        }
        
    }
    
    func showHistoryView() {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        let view = HistoryView.instantiateFromNib()
        view.configure(idCoin: id)
        view.frame = containerView.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(view)
    }
    
    func showChartView() {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        let view = ChartView(idCoin: id)
        view.idCoin = id
        view.frame = containerView.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(view)
    }
    
}
