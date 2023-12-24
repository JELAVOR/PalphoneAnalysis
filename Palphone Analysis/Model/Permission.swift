//
//  Permission.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/24/23.
//

import Foundation

struct Permission: Codable {
    let name: String
    let value: Int
    let actions: [Action]
}
