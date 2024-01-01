import Foundation
import UIKit
import Alamofire


class AccessTokenInterceptor: RequestInterceptor {
    
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else {
            completion(.failure(CustomError.NoAccount))
            return
        }
        var newRequest = urlRequest
        newRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        completion(.success(newRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode, statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        refreshToken { success in
            if success {
                completion(.retry)
            } else {
                print("Token refresh failed. Unable to retry the request.")
                completion(.doNotRetry)
            }
        }
    }

    func refreshToken(completion: @escaping (_ success: Bool) -> Void) {
        guard let token = AppUserDefaults().refreshToken else {
            completion(false)
            return
        }

        let refreshTokenURL = "https://boapi.palphone.com/user/token"
        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        var headers =  HTTPHeaders()
        headers.add(header)

        AF.request(refreshTokenURL, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Base.self) { response in
                switch response.result {
                case .success(let newTokens):
                    
                    AppUserDefaults().accessToken = newTokens.tokens.accessToken
                    AppUserDefaults().refreshToken = newTokens.tokens.refreshToken
                    completion(true)

                case .failure(let error):
                    print("Token refresh failed. Error: \(error.localizedDescription)")
                    completion(false)
                }
            }
    }
}
