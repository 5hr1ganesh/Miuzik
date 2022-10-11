//
//  SearchResultRES.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 10/10/22.
//

import Foundation

enum SearchResultRES {
    case artist(model: Artists)
    case album(model: Album)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
}
