//
//  LoginService.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/31/23.
//

import Foundation

import Alamofire

class LoginService {

    func login(email: String, password: String, completion: @escaping (Result<Aliz, Error>) -> Void) {
        let baseUrl = "https://boapi.palphone.com"
        let loginURL = baseUrl + "/v1/login"

        let loginData = LoginRequest(email: email, password: password)

        AF.request(loginURL, method: .post, parameters: loginData, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Aliz.self) { response in
                switch response.result {
                case .success(let aliz):
                    completion(.success(aliz))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
