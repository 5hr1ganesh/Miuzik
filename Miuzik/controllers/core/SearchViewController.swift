//
//  SearchViewController.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 28/08/22.
//
import SafariServices
import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    
    
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
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .fractionalHeight(1)))
            
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
    
    private var categories = [Category]()
    
    //    Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        APIcaller.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case.success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self

        APIcaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    resultsController.update(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
    
    }
    
    
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ result: SearchResultRES) {
        switch result {
        case .artist(let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        case .album(let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(let track):
            PlayBackPresenter.shared.startPlayback(from: self, track: track)
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifier,
            for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewCellViewModel(
            title: category.name,
            artworkURL: URL(string: category.icons.first?.url ?? "")))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

