import Foundation

//struct Welcome: Codable {
//    let data: [Talk]
//    let meta: Meta
//    let aliz: Aliz?
//    let aliz2: Aliz2?
//}
//
//struct Talk: Codable {
//    let talkId: Int
//    let languageId: Int
//    let createdAt: String
//    let duration: Int
//    let status: Int
//    let plan: Int
//    let mediaDomain: String
//    let reconnectionCount: Int
//    let reason: Int
//    let finisherId: Int
//    let pals: [TalkPal]
//    let type: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case talkId, languageId, createdAt, duration, status, plan
//        case mediaDomain, reconnectionCount, reason, finisherId, pals, type
//    }
//}
//
//struct TalkPal: Codable {
//    let talkId: Int
//    let accountId: Int
//    let characterId: Int
//    let platform: Int
//    let appVersion: AppVersion
//    let ip: String
//    let country: Country
//    let internetQuality: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case talkId, accountId, characterId, platform, appVersion, ip, country, internetQuality
//    }
//}
//
//enum AppVersion: String, Codable {
//    case v121 = "1.2.1"
//    case v206 = "2.0.6"
//    case v208 = "2.0.8"
//}
//
//enum Country: String, Codable {
//    case algeria = "Algeria"
//    case egypt = "Egypt"
//    case empty = ""
//    case india = "India"
//    case iran = "Iran"
//    case pakistan = "Pakistan"
//}
//
//struct Meta: Codable {
//    let total: Int
//    let perPage: Int
//    let currentPage: Int
//    let lastPage: Int
//}

// MARK: - Welcome
struct Welcome: Codable {
    let data: [Talk]
    let meta: Meta
}

// MARK: - Datum
struct Talk: Codable {
    let talkId, languageId: Int
    let createdAt: String
    let duration, status, plan: Int
    let mediaDomain: String
    let reconnectionCount, reason, finisherID: Int
    let pals: [TalkPal]
    let type: Int

    enum CodingKeys: String, CodingKey {
        case talkId = "talk_id"
        case languageId = "language_id"
        case createdAt = "created_at"
        case duration, status, plan
        case mediaDomain = "media_domain"
        case reconnectionCount = "reconnection_count"
        case reason
        case finisherID = "finisher_id"
        case pals, type
    }
}

// MARK: - Pal
struct TalkPal: Codable {
    let talkId, accountId, characterId, platform: Int
    let appVersion: AppVersion
    let ip: String
    let country: Country
    let internetQuality: Int

    enum CodingKeys: String, CodingKey {
        case talkId = "talk_id"
        case accountId = "account_id"
        case characterId = "character_id"
        case platform
        case appVersion = "app_version"
        case ip, country
        case internetQuality = "internet_quality"
    }
}

enum AppVersion: String, Codable {
    case the121 = "1.2.1"
    case the206 = "2.0.6"
    case the208 = "2.0.8"
}

enum Country: String, Codable {
    case algeria = "Algeria"
    case egypt = "Egypt"
    case empty = ""
    case india = "India"
    case iran = "Iran"
    case pakistan = "Pakistan"
}

// MARK: - Meta
struct Meta: Codable {
    let total, perPage, currentPage, lastPage: Int

    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
    }
}
