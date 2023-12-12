import UIKit
import Alamofire

class YourTableViewController: UITableViewController {
    var callData: Welcome?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        tableView.backgroundColor = UIColor.cyan
        tableView.separatorColor = UIColor.white
        
        tableView.tableHeaderView?.backgroundColor = UIColor.cyan
        tableView.tableFooterView?.backgroundColor = UIColor.cyan
        
       
        UserDefaults.standard.set("invalid_token", forKey: "AccessToken")

        
        // Fetch call data reports
        fetchCallDataReports()
  
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    func fetchData(with jwt: String, from url: URL, completion: @escaping (Result<Welcome, Error>) -> Void) {
        var request = URLRequest(url: url)
        let interceptor = AccessTokenInterceptor()
        AF.request(request, interceptor: interceptor)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Welcome.self) { response in
                switch response.result {
                case .success(let responseData):
                    completion(.success(responseData))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 401 {
                        // Unauthorized, JWT expired or invalid
                        completion(.failure(AuthError.jwtExpired))
                    } else {
                        // Other failure
                        completion(.failure(error))
                    }
                    
                    if let data = response.data {
                        let responseString = String(data: data, encoding: .utf8)
                        print("Response String: \(responseString ?? "Unable to convert data to string")")
                    }
                }
            }
    }
    
    func fetchCallDataReports() {
        

        // Fetch access token from UserDefaults
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else {
            // Handle the case where the access token is not available
            return
        }
        
        // Specify your desired date range
        let urlString = "https://boapi.palphone.com/admin/reports/talks?from=2023-05-07T08%3A00%3A00Z&to=2023-05-07T08%3A59%3A59Z"
        
        guard let url = URL(string: urlString) else {
            // Handle invalid URL
            return
        }
        
        // Call the function to fetch and parse JSON with the JWT
        fetchData(with: accessToken, from: url) { result in
               switch result {
               case .success(let callData):
                   // Show the fetched data in an alert
                   self.showFetchedDataAlert(data: callData)

                   // Handle successful call data fetching
                   self.callData = callData
                   self.tableView.reloadData()
                   print("Call data fetched successfully")

               case .failure(let error):
                   // Handle call data fetching failure
                   switch error {
                   case AuthError.jwtExpired:
                       // JWT expired, prompt user to log in again
                       print("JWT expired. Please log in again.")
                       // You may want to show an alert or navigate to the login screen
                   default:
                       print("Failed to fetch call data. Error: \(error.localizedDescription)")
                   }
               }
           }
       }

       func showFetchedDataAlert(data: Welcome) {
           let alert = UIAlertController(title: "Fetched Data", message: "\(data)", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    
    enum AuthError: Error {
        case jwtExpired
    }
}

let session = Session(interceptor: AccessTokenInterceptor())
class AccessTokenInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else {
            completion(.failure(fatalError("Access token not found")))
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
                print("1")
                completion(.retry)
            } else {
//                print("2")

                completion(.doNotRetry)
            }
        }
    }
    func refreshToken(completion: @escaping (_ success: Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "RefreshToken") else {
//            print("6 \(token)")
            completion(false) // No refresh token found
            return
        }
        
        print("7 \(token)")

        let refreshTokenURL = "https://boapi.palphone.com/user/token"
//        let parameters: [String: String] = ["refresh_token": refreshToken]
        
        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        var headers =  HTTPHeaders()
        headers.add(header)
        
        AF.request(refreshTokenURL, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Aliz2.self) { response in
                switch response.result {
                case .success(let newTokens):
                    print("8 \(response) +++ \(newTokens)")
                    // Update the UserDefaults with the new access token and refresh token
                    UserDefaults.standard.set(newTokens.tokens.accessToken, forKey: "AccessToken")
                    UserDefaults.standard.set(newTokens.tokens.refreshToken, forKey: "RefreshToken")
                    completion(true) // Token refresh successful
                    
                case .failure(let error):
                    print("3 \(response)")

//                    print("Token refresh failed. Error: \(error.localizedDescription)")
                    completion(false) // Token refresh failed
                }
            }
    }
}
