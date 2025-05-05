//
//  CoinViewCell.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import UIKit
import SDWebImage

class CoinViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var coinNameLbl: UILabel!
    @IBOutlet weak var currentPriceLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    private var selectedCoin: Coin?
    private var isFavorited = false
    
    var onTapFavorite: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1.0
    }
    
    func setupCell(coin: Coin){
        selectedCoin = coin
        coinNameLbl.text = coin.name
        currentPriceLbl.text = String(coin.currentPrice)
        let url = URL(string: coin.image ?? "")
        logoImg.sd_setImage(with: url,placeholderImage: UIImage(systemName: "photo"), options: [.retryFailed, .continueInBackground])
    }
    
    @IBAction func favoriteBtn(_ sender: Any) {
        self.onTapFavorite?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
