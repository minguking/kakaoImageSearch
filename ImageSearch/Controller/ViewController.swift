//
//  ViewController.swift
//  ImageSearch
//
//  Created by Kang Mingu on 2020/11/02.
//

import UIKit

import Kingfisher

private let cellID = "ImageCell"

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let noImageState: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "noResult")
        iv.isHidden = true
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOffset = CGSize(width: 0, height: 0)
        iv.layer.shadowRadius = 20
        iv.layer.shadowOpacity = 0.9
        return iv
    }()
    
    private let pleaseSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "↑\n검색을 해주세요"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: customTextColor)
        return label
    }()
    
    var result = [Results]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        layout.scrollDirection = .vertical
        return cv
    }()
    
    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "이곳에 검색어를 입력해주세요!"
        return sc
    }()
    
    private var searchText = ""
    private var page = 1
    private var isEnd: Bool = false
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        title = "검색을 생활화"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        view.backgroundColor = UIColor(named: customViewColor)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchResultImageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = UIColor(named: customViewColor)
        
        view.addSubview(collectionView)
        view.addSubview(noImageState)
        view.addSubview(pleaseSearchLabel)
        
        noImageState.centerX(inView: view)
        noImageState.centerY(inView: view)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                              bottom: view.bottomAnchor, right: view.rightAnchor)
        pleaseSearchLabel.center(inView: view)
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                      for: indexPath) as! SearchResultImageCell
        
        cell.imageView.kf.setImage(with: URL(string: result[indexPath.item].thumbnail_url))
        
        return cell
        
    }
    
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ImageDetailViewController(imageInfo: result[indexPath.item])
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 32) / 3,
                      height: (collectionView.frame.width - 32) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching

extension ViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let nextRow = indexPaths.map { $0.row }

        if let maxIndex = nextRow.max(), maxIndex >= (self.page * 30) - 10 {
            self.page += 1
            SearchService.shared.imageSearch(keyWord: searchText, page: self.page) { results in
                
                self.result += results
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UISearchControllerDelegate/UISearchBarDelegate

extension ViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("DEBUG: search button tapped")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.result = []
        self.noImageState.isHidden = true
        collectionView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = searchText
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.pleaseSearchLabel.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.searchText = searchText
            
            self.result = []
            self.page = 1
            self.noImageState.isHidden = true
            
            SearchService.shared.imageSearch(keyWord: searchText, page: 1) { results in
                
                self.result = results
                self.collectionView.reloadData()
                
                if self.result.isEmpty && !searchText.isEmpty {
                    self.noImageState.isHidden = false
                    self.pleaseSearchLabel.isHidden = true
                } else if self.result.isEmpty && searchText.isEmpty {
                    self.noImageState.isHidden = true
                    self.pleaseSearchLabel.isHidden = false
                }
            }
        }
    }
    
    
}
