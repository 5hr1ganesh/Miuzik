//
//  LoginResponse.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 12/09/22.
//

import Foundation
struct Loginresponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}

