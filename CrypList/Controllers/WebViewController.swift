//
//  WebViewController.swift
//  CrypList
//
//  Created by Dwistari on 04/05/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shop"
        view.backgroundColor = .white
        setupWebView()
        loadInitialURL()
    }

    func setupWebView() {
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
    }

    func loadInitialURL() {
        if let url = URL(string: "https://enchanting-sherbet-a8657d.netlify.app/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // Intercept URL redirection
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }

        if url.contains("https://www.placeholder.com/") {
            let vc = ReceiptViewController()
            navigationController?.pushViewController(vc, animated: true)
            decisionHandler(.cancel)
        } else if url.contains("https://example.com/") {
            let vc = ThankYouViewController()
            navigationController?.pushViewController(vc, animated: true)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
