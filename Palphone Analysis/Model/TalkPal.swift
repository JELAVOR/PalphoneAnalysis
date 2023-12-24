//
//  TalkPal.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/24/23.
//

import Foundation

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
