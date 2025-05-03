//
//  HistoryView.swift
//  CrypList
//
//  Created by Dwistari on 02/05/25.
//

import UIKit

class HistoryView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [String] = ["A","B","C","D"]
    
    static func instantiateFromNib() -> HistoryView {
        let nib = UINib(nibName: "HistoryView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! HistoryView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
        
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryCell")
    }
    
}

extension HistoryView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        cell.setData(price: data[indexPath.row])
        return cell
    }
}


