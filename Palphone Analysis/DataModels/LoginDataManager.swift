//
//  LoginDataManager.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/6/23.
//

import Foundation

// MARK: - Welcome
struct Aliz: Codable {
    let tokens: Tokens
    let permissions: [Permission]
}
// MARK: - Permission
struct Permission: Codable {
    let name: String
    let value: Int
    let actions: [Action]
}

// MARK: - Action
struct Action: Codable {
    let name: Name
    let value: Int
}

enum Name: String, Codable {
    case create = "create"
    case delete = "delete"
    case empty = "*"
    case read = "read"
    case update = "update"
}

// MARK: - Tokens
struct Tokens: Codable {
    var accessToken, refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}



struct Aliz2: Codable{
    let tokens: Tokens
}
