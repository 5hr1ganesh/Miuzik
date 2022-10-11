//
//  PlayBackPresenter.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 11/10/22.
//
import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlayBackPresenter {
    
    static let shared = PlayBackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var index = 0
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
            
        } else if let player = self.playerQueue, !tracks.isEmpty
        {
            return tracks[index]
        }
        
        return nil
    }
    var playVC: PlayViewController?
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        self.track = track
        self.tracks = []
        let vc = PlayViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playVC = vc
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        self.tracks = tracks
        self.track = nil
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()
        
        let vc = PlayViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        self.playVC = vc
    }
}



extension PlayBackPresenter: PlayViewControllerDelegate{
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
        }else if let player = playerQueue
        {   player.advanceToNextItem()
            index += 1
            print(index)
            playVC?.refreshUI()
        }
    }
    
//    func didTapBackward() {
//        if tracks.isEmpty {
//            // Not playlist or album
//            player?.pause()
////            player?.play()
//        }else if let firstItem = playerQueue?.items().first
//        {   player?.appliesMediaSelectionCriteriaAutomatically = true
//            index -= 1
//            print(index)
//            playVC?.refreshUI()
//            playerQueue?.pause()
//            playerQueue?.removeAllItems()
//            playerQueue = AVQueuePlayer(items: [firstItem])
//            playerQueue?.play()
//            playerQueue?.volume = 0.5
//        }
//    }
    
}

extension PlayBackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
//        print(currentTrack?.album?.images)
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
}
