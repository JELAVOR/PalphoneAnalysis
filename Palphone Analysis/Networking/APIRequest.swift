//
//  APIRequest.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/24/23.
//


import Foundation
import Alamofire

class APIRequest {
    static let shared = APIRequest()

    private init() {}

    func fetchData<T: Decodable>(url: URL, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}