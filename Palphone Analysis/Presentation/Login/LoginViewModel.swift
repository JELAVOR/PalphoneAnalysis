//
//  LoginViewModel.swift
//  Palphone Analysis
//
//  Created by palphone ios on 1/2/24.
//
import Foundation

class LoginViewModel {
    private let loginService: LoginService
    var loginModel: LoginModel
    
    init(loginService: LoginService) {
        self.loginService = loginService
        self.loginModel = LoginModel(email: "", password: "")
    }
    
    func login(completion: @escaping (Result<Aliz, Error>) -> Void) {
        loginService.login(email: loginModel.email, password: loginModel.password, completion: completion)
    }
}
