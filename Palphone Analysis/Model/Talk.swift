//
//  Talk.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/24/23.
//

import Foundation

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
