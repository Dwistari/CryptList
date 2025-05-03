//
//  CategoryViewCell.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 4
    }
    
    func setupCell(data: CoinCategory) {
        categoryLbl.text = data.name
        
        if data.name == "Favorite" {
            containerView.backgroundColor = UIColor.systemGreen
            categoryLbl.textColor =  UIColor.white
        }
        
    }
    
}
