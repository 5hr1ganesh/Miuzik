//
//  AllCategoryres.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 10/10/22.
//

import Foundation

struct AllCategoryres: Codable {
    let categories: Categories
    
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}
