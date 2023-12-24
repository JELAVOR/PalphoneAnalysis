//
//  Meta.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/24/23.
//

import Foundation

struct Meta: Codable {
    let total, perPage, currentPage, lastPage: Int

    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
    }
}
