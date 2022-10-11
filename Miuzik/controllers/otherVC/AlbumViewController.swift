//
//  AlbumViewController.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 08/10/22.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ -> NSCollectionLayoutSection in
                
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                )
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 1,
                    leading: 2,
                    bottom: 2,
                    trailing: 2)
                
                //group
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(60)),
                    subitem: item,
                    count: 1)
                //section
                let section = NSCollectionLayoutSection(group: verticalGroup)
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(1)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                return section
            })
    )
    
    private let album: Album
    private var tracks = [AudioTrack]()
    private var viewmodel = [AlbumCollectionViewCellVM]()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.register(
            AlbumTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumTracksCollectionViewCell.identifier)
        collectionView.register(
            PlaylistheaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistheaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APIcaller.shared.getAlbumDetails(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewmodel = model.tracks.items.compactMap({
                        AlbumCollectionViewCellVM(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-"
                        )})
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
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTracksCollectionViewCell.identifier,
            for: indexPath) as? AlbumTracksCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .orange
        cell.configure(with: viewmodel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistheaderCollectionReusableView.identifier,
            for: indexPath) as? PlaylistheaderCollectionReusableView,
        
            kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderVM(
            name: album.name,
            ownerName: album.artists.first?.name ?? "-",
            description: "Release Date: \(String.formattedDate(str: album.release_date))",
            artworkUrl: URL(string: album.images.first?.url ?? ""))
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var track = tracks[indexPath.row]
        track.album = self.album
        PlayBackPresenter.shared.startPlayback(from: self, track: track)
    }
}

extension AlbumViewController: PlaylistheaderCollectionReusableViewDelegate {
    func playlistheaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistheaderCollectionReusableView) {
        let trackswithAlbum: [AudioTrack] = tracks.compactMap {
            var track = $0
            track.album = self.album
            return track
        }
        PlayBackPresenter.shared.startPlayback(from: self, tracks: trackswithAlbum)
    }
}
