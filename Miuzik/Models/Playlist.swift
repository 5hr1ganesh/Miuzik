//
//  Playlist.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 29/08/22.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let snapshot_id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
