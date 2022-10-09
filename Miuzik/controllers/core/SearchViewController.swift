//
//  SearchViewController.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 28/08/22.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    
    
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Artists, Albums, music"
        vc.searchBar.searchBarStyle = .minimal
        vc.searchBar.isTranslucent = true
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 6,
                bottom: 2,
                trailing: 6)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(160)),
                subitem: item,
                count: 2)
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 6,
                leading: 5,
                bottom: 6,
                trailing: 5)
            
            return NSCollectionLayoutSection(group: group)
            
        }))
    
    //    Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(
            GenreCollectionViewCell.self,
            forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        //        resultsController.update(with: results)
        print(query)
        //        Perform Search
        //        APIcaller.shared.search
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: GenreCollectionViewCell.identifier,
        for: indexPath) as? GenreCollectionViewCell else {
           return UICollectionViewCell()
       }
        cell.configure(with: "Rap")
        return cell
    }
}
