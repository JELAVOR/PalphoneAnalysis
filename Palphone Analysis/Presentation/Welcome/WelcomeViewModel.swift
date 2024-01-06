//
//  WelcomeViewModel.swift
//  Palphone Analysis
//
//  Created by palphone ios on 1/2/24.
//

import Foundation
import UIKit



class WelcomeViewModel {
    var loginService: LoginService
    var navigateToTableView: (() -> Void)?

    init(loginService: LoginService) {
        self.loginService = loginService
    }

    func animateTitle(completion: @escaping (Character) -> Void) {
        var charIndex = 0.0
        let titleText = "Palphone Analysis"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                completion(letter)
            }
            charIndex += 1
        }
    }

    func loginButtonPressed() {
      
        let accessToken = AppUserDefaults().accessToken
        navigateToTableView?()
    }
}
