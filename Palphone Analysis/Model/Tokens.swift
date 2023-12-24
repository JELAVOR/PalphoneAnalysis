//
//  Tokens.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/24/23.
//

import Foundation


struct Tokens: Codable {
    var accessToken, refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
