//
//  Albumdetailsres.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 08/10/22.
//

import Foundation


struct Albumdetailsres: Codable{
    let album_type: String
    let artists: [Artists]
    let available_markets: [String]
    let external_urls: [String:String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: Trackresponse
    
}

struct Trackresponse: Codable{
    let items: [AudioTrack]
}

