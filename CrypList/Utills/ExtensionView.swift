//
//  ExtensionView.swift
//  CrypList
//
//  Created by Dwistari on 03/05/25.
//

import UIKit

extension UIView {
    func showToast(message: String, duration: Double = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0

        let padding: CGFloat = 16
        let maxWidthPercentage: CGFloat = 0.8
        let maxMessageSize = CGSize(width: self.frame.width * maxWidthPercentage, height: self.frame.height)
        var expectedSize = toastLabel.sizeThatFits(maxMessageSize)
        expectedSize.width += padding
        expectedSize.height += padding

        toastLabel.frame = CGRect(x: (self.frame.size.width - expectedSize.width)/2,
                                  y: self.frame.size.height - expectedSize.height - 50,
                                  width: expectedSize.width,
                                  height: expectedSize.height)
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        self.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: [], animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
