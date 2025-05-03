//
//  HistoryCell.swift
//  CrypList
//
//  Created by Dwistari on 02/05/25.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(price: String) {
        dateLbl.text = price
        priceLbl.text = price
    }
    
}
