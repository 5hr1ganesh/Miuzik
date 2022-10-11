//
//  SearchResults.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 10/10/22.
//

import Foundation


struct SearchResults: Codable {
    let albums: SearchResultsAlbum
    let artists: SearchResultsArtist
    let playlists: SearchResultsPlaylist
    let tracks: SearchResultsTracks
}

struct SearchResultsAlbum: Codable {
    let items: [Album]
}

struct SearchResultsArtist: Codable {
    let items: [Artists]
}

struct SearchResultsPlaylist: Codable {
    let items: [Playlist]
}

struct SearchResultsTracks: Codable {
    let items: [AudioTrack]
}
