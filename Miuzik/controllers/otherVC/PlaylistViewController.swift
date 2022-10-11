//
//  LibraryViewController.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 28/08/22.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    private let playlist: Playlist
    public var isOwner = false
    
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
    
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var viewmodel = [RecommendedTrackCellVM]()
    private var tracks = [AudioTrack]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.register(
            RecommendedTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.register(
            PlaylistheaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistheaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APIcaller.shared.getPlaylistDetails(for: playlist) {[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case.success(let model):
                    //RecommendedTrackCellVM
                    self?.tracks = model.tracks.items.compactMap({$0.track})
                    self?.viewmodel = model.tracks.items.compactMap({
                        RecommendedTrackCellVM(
                            name: $0.track.name,
                            artistName: $0.track.artists.first?.name ?? "-",
                            artworkURL: URL(string: $0.track.album?.images.first?.url ?? "")
                        )})
                    self?.collectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        let trackToDelete = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(
            title: trackToDelete.name,
            message: "Would you like to remove this from the playlist?",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(
            UIAlertAction(
                title: "Remove",
                style: .destructive,
                handler: { [weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }
                    APIcaller.shared.removeTrackFromPlaylist(track: trackToDelete, playlist: strongSelf.playlist) { success in
                        DispatchQueue.main.async {
                            if success {
                                strongSelf.tracks.remove(at: indexPath.row)
                                strongSelf.viewmodel.remove(at: indexPath.row)
                                strongSelf.collectionView.reloadData()
                            }
                            else {
                                print("Failed to remove")
                            }
                        }
                    }
                }
            )
        )
        present(actionSheet,
                animated: true,
                completion: nil)
    }
    
    @objc private func didTapShare() {
        guard let url = URL(string: playlist.external_urls["spotify"]  ?? "") else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier,
            for: indexPath) as? RecommendedTracksCollectionViewCell else {
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
            name: playlist.name,
            ownerName: playlist.owner.display_name,
            description: playlist.description,
            artworkUrl: URL(string: playlist.images.first?.url ?? ""))
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = indexPath.row
        let track = tracks[index]
        PlayBackPresenter.shared.startPlayback(from: self, track: track)
    }
}

extension PlaylistViewController: PlaylistheaderCollectionReusableViewDelegate {
    func playlistheaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistheaderCollectionReusableView) {
        PlayBackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}

