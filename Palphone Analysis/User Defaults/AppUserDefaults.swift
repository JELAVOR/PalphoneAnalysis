//
//  AppUserDefaults.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/24/23.
//

import Foundation


class AppUserDefaults {
    static let shared = AppUserDefaults()

    private init() {}

    // MARK: - Access Token
    var accessToken: String? {
        get { UserDefaults.standard.string(forKey: UserDefaultsKey.accessToken.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.accessToken.rawValue) }
    }

    // MARK: - Refresh Token
    var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: UserDefaultsKey.refreshToken.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.refreshToken.rawValue) }
    }

    // MARK: - Clear Tokens
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.accessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.refreshToken.rawValue)
    }
}
