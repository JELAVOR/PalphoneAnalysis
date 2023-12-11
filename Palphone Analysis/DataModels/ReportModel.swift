//
//  reportModel.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/10/23.
//
import Foundation

struct Welcome: Codable {
    let tokens: Tokens
    let permissions: [Permission] 
    let data: [Datum]
    let meta: Meta
}
struct Datum: Codable {
    let talk_id: Int
    let language_id: Int
    let created_at: String
    let duration: Int
    let status: Int
    let plan: Int
    let media_domain: String
    let reconnection_count: Int
    let reason: Int
    let finisher_id: Int
    let pals: [Pal]
    let type: Int

    enum CodingKeys: String, CodingKey {
        case talk_id, language_id, created_at, duration, status, plan
        case media_domain, reconnection_count, reason, finisher_id, pals, type
    }
}

struct Pal: Codable {
    let talk_id: Int
    let account_id: Int
    let character_id: Int
    let platform: Int
    let app_version: String
    let ip: String
    let country: String
    let internet_quality: Int

    enum CodingKeys: String, CodingKey {
        case talk_id, account_id, character_id, platform, app_version, ip, country, internet_quality
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

struct Meta: Codable {
    let total: Int
    let per_page: Int
    let current_page: Int
    let last_page: Int
}

struct Talk: Codable {
    let talkId: Int
    let languageId: Int
    let createdAt: String
    let duration: Int
    let status: Int
    let pals: [Pal]
    // Add other properties as needed

    struct Pal: Codable {
        let accountId: Int
        let characterId: Int
        let platform: Int
        let appVersion: String
        let ip: String
        let country: String
        let internetQuality: Int
        // Add other properties as needed
    }
}
