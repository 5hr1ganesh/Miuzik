//
//  SettingsModels.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 18/09/22.
//

import Foundation


struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title:String
    let handler: () -> Void
}
