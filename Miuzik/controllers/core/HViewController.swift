//
//  ViewController.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 28/08/22.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellVM])
    case featuredTracks(viewModels: [NewReleasesCellVM])
    case recommendedTracks(viewModels: [NewReleasesCellVM])
}

class HViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
            case .newReleases(let viewModels):
                return viewModels.count
            case .featuredTracks(let viewModels):
                return viewModels.count
            case .recommendedTracks(let viewModels):
                return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewRelesesCollectionViewCell.identifier,
                for: indexPath
            ) as? NewRelesesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath
            ) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier,
                for: indexPath
            ) as? RecommendedTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .orange
            return cell
    }
    }
    
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                    collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex,_ -> NSCollectionLayoutSection? in
        return HViewController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
                                                            configureCollectionView()
                                                            view.addSubview(spinner)
                                                            fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(NewRelesesCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewRelesesCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTracksCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
     static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section{
        case 0:
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(400)),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.94),
                    heightDimension: .absolute(400)),
                subitem: verticalGroup,
                count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
            
            
        case 1:
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(225),
                                                                                 heightDimension: .absolute(225))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(225),
                    heightDimension: .absolute(450)),
                subitem: item,
                count: 2)
           
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(225),
                    heightDimension: .absolute(450)),
                subitem: verticalGroup,
                count: 1)
            //section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
            
            //group
            
            
            
            
        case 2:
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .absolute(60))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(90)),
                subitem: item,
                count: 1)
            
          
            //section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            
            return section
            
        default:
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(400)),
                subitem: item,
                count: 1)
            //section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        print("Starting API calls")
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistResponse?
        var recommendations: RecommendationsResponse?
        
        //new releases
        APIcaller.shared.getNewReleases { result in
            defer{
                group.leave()
            }
            switch result{
            case.success(let model):
                newReleases = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
        // Featured Playlists
        APIcaller.shared.getFeaturedPlaylist { result in
            defer{
                group.leave()
            }
            switch result{
            case.success(let model):
                featuredPlaylist = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
        
        //recommended tracks
        APIcaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                APIcaller.shared.getRecommendations(genres: seeds) { recommendedresult in
                    defer{
                        group.leave()
                    }
                    switch recommendedresult{
                    case.success(let model):
                        recommendations = model
                    case.failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            guard let releases = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else {
                fatalError("Models are nil")
                return
            }
            print("Configuring viewmodels")
            self.configureModels(newAlbum: releases, playlists: playlists, tracks: tracks)
        }
        
    }
    
    private func configureModels(
        newAlbum: [Album],
        playlists: [Playlist],
        tracks: [AudioTrack]
    ) {
        print(newAlbum.count)
        print(playlists.count)
        print(tracks.count)
        //Configure Models
        sections.append(.newReleases(viewModels: newAlbum.compactMap({
            return NewReleasesCellVM(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? ""
            )
        })))
        sections.append(.featuredTracks(viewModels: []))
        sections.append(.recommendedTracks(viewModels: []))
        collectionView.reloadData()
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

