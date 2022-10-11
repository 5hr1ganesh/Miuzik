//
//  LibraryAlbumsResponse.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 11/10/22.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
