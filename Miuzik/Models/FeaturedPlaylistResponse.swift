//
//  FeaturedPlaylistResponse.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 24/09/22.
//

import Foundation

struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistReponse
}

struct PlaylistReponse: Codable {
    let items: [Playlist]
}



struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
    
}
