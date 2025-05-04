//
//  ThankYouViewController.swift
//  CrypList
//
//  Created by Dwistari on 04/05/25.
//

import UIKit

class ThankYouViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Thank You"

        let label = UILabel()
        label.text = "🎉 Terima kasih, pembelianmu berhasil!"
        label.textAlignment = .center
        label.frame = view.bounds.insetBy(dx: 20, dy: 100)
        view.addSubview(label)
    }
}
