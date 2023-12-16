import Foundation

// MARK: - Aliz
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
    let name: ActionName
    let value: Int
}

enum ActionName: String, Codable {
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

// MARK: - Aliz2
struct Aliz2: Codable {
    let tokens: Tokens
}
