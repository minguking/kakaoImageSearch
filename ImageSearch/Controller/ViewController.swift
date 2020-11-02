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
        iv.tintColor = .black
        iv.image = UIImage(named: "noresult")
        iv.isHidden = true
        return iv
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
        
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchResultImageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .black
        
        view.addSubview(collectionView)
        collectionView.addSubview(noImageState)
        
        noImageState.centerX(inView: collectionView)
        noImageState.centerY(inView: collectionView)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                              bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SearchResultImageCell
        
        cell.imageView.kf.setImage(with: URL(string: result[indexPath.item].thumbnail_url))
        cell.backgroundColor = .systemPink
        
        return cell
        
    }
    
    
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 32) / 3, height: (collectionView.frame.width - 32) / 3)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.item == lastRow {
            
        }
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("DEBUG: search button tapped")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.result = []
        self.noImageState.isHidden = true
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.result = []
            self.noImageState.isHidden = true
            
            SearchService.shared.imageSearch(keyWord: searchText, page: self.page) { json in
                
//                print("DEBUG: json === \(json["meta"]["is_end"])")
                
                print("DEBUG: json == \(json)")
                
                
                var results = Results()
                for item in json["documents"].arrayValue {
                    results.collection = item["collection"].stringValue
                    results.display_sitename = item["display_sitename"].stringValue
                    results.thumbnail_url = item["thumbnail_url"].stringValue
                    self.result.append(results)
                }
                self.collectionView.reloadData()
                
                if self.result.isEmpty && !searchText.isEmpty {
                    self.noImageState.isHidden = false
                } else if self.result.isEmpty && searchText.isEmpty {
                    self.noImageState.isHidden = true
                }
            }
        }
    }
}
