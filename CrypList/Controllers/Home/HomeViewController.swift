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
    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    var filteredCoins: [Coin] = []
    var allCoins: [Coin] = []
    var favoriteCoins: [Coin] = []
    
    var isFavoriteShow: Bool = false
    
    lazy var viewModel: HomeViewModel = {
        let viewModel = HomeViewModel(service: APIService())
        return viewModel
    }()
    
    private var displayedCoins: [Coin] {
          return isFavoriteShow ? favoriteCoins : allCoins
      }
    
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
                    self.emptyLbl.isHidden =  false
                }
                self.allCoins = self.viewModel.allCoins
                self.listTableView.reloadData()
            }
        }
       
        allCoins = viewModel.allCoins
        favoriteCoins = CoreDataManager.shared.fetchFavorites()
    }
    
    func filterCoins(by type: String) {
        self.showLoading()
        viewModel.filter = type
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
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        isFavoriteShow = sender.selectedSegmentIndex == 1
        emptyLbl.isHidden = displayedCoins.count > 0
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
    
    
    @IBAction func openWebView(_ sender: Any) {
        let vc = WebViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isFavoriteShow ? favoriteCoins.count : allCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinViewCell", for: indexPath) as? CoinViewCell else {
            return UITableViewCell()
        }
        
        let coin =  isFavoriteShow ? favoriteCoins[indexPath.row] : allCoins[indexPath.row]
        let isFavorited = favoriteCoins.contains { $0.id == coin.id }

        let imageName = isFavorited ? "heart.fill" : "heart"
        cell.favoriteBtn.setImage(UIImage(systemName: imageName), for: .normal)
                
        cell.setupCell(coin: coin)
        cell.onTapFavorite = { [weak self] in
            guard let self = self else { return }
            CoreDataManager.shared.saveFavorite(isFavorite: !isFavorited, coin: coin)
            
            // Refresh favorites and reload cell
            self.favoriteCoins = CoreDataManager.shared.fetchFavorites()
            self.listTableView.reloadData()
            self.emptyLbl.isHidden = self.displayedCoins.count > 0
     }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin =  isFavoriteShow ? favoriteCoins[indexPath.row] : allCoins[indexPath.row]
        let vc = DetailCoinViewController(coin: coin)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == listTableView else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 1.5 {
            self.listTableView.tableFooterView = createTableFooterSpinner()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else {return}
                self.viewModel.page += 1
                self.viewModel.fetchCoinList { [weak self] in
                    DispatchQueue.main.async {
                        self?.listTableView.tableFooterView = nil
                        self?.listTableView.reloadData()
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

