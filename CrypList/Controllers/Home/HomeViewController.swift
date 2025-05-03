//
//  HomeViewController.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var listTableView: UITableView!
    var filteredCoins: [Coin] = []
    
    var allCoins: [Coin] = []
   
    lazy var viewModel: HomeViewModel = {
        let viewModel = HomeViewModel(service: APIService())
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        setTableView()
        setCollectionView()
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        loadData()
    }
    
    func setTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.separatorStyle = .none
        let nib = UINib(nibName: "CoinViewCell", bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: "CoinViewCell")
    }
    
    func setCollectionView() {
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        let nib = UINib(nibName: "CategoryViewCell", bundle: nil)
        filterCollectionView.register(nib, forCellWithReuseIdentifier: "CategoryCell")
        
        if let layout = filterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
        }
    }
    
    func loadData() {
        self.showLoading()
        viewModel.fetchCategoryList { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.hideLoading()
                let msg = self.viewModel.errorMsg
                if !msg.isEmpty {
                    self.showToastError(message: msg)
                }
                self.filterCollectionView.reloadData()
            }
        }
        
        viewModel.fetchCoinList { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.hideLoading()
                let msg = self.viewModel.errorMsg
                if !msg.isEmpty {
                    self.showToastError(message: msg)
                }
                self.allCoins = self.viewModel.allCoins
                self.listTableView.reloadData()
            }
        }
    }
    
    func filterCoins(by type: String) {
        self.showLoading()
        viewModel.filter = type
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.fetchCoinList { [weak self] in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.hideLoading()
                    let msg = self.viewModel.errorMsg
                    if !msg.isEmpty {
                        self.showToastError(message: msg)
                    }
                    self.listTableView.reloadData()
                }
            }
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            allCoins = viewModel.allCoins
        } else {
            allCoins = CoreDataManager.shared.fetchFavorites()
        }
        listTableView.reloadData()
    }
    
    private func createTableFooterSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: listTableView.bounds.width, height: 50))
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = footerView.center
        spinner.startAnimating()
        footerView.addSubview(spinner)
        return footerView
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinViewCell", for: indexPath) as? CoinViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(coin: allCoins[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailCoinViewController()
        vc.coin = allCoins[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == listTableView else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.5 {
            self.listTableView.tableFooterView = createTableFooterSpinner()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.viewModel.page += 1
                self.viewModel.fetchCoinList {
                    DispatchQueue.main.async {
                        self.listTableView.tableFooterView = nil
                        self.listTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = viewModel.categories[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(data: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedType =  viewModel.categories[indexPath.item].id
        filterCoins(by: selectedType)
    }
}

