//
//  ReceiptViewController.swift
//  CrypList
//
//  Created by Dwistari on 04/05/25.
//

import Foundation
import UIKit

class ReceiptViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Receipt"

        let label = UILabel()
        label.text = """
        🧾 Receipt
        Item: Premium Product
        Price: $99.00
        """
        label.numberOfLines = 0
        label.textAlignment = .center
        label.frame = view.bounds.insetBy(dx: 40, dy: 100)
        view.addSubview(label)
    }
}
