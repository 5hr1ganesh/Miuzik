//
//  Playlistdetailsres.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 08/10/22.
//

import Foundation

struct Playlistdetailsres: Codable{
    let description: String
    let external_urls:[String: String]
//    let followers: String
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTrackresponse
}

struct PlaylistTrackresponse: Codable{
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable{
    let track: AudioTrack
}

