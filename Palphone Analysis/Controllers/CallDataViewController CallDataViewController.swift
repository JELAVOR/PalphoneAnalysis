import UIKit
import Alamofire

class YourTableViewController: UITableViewController {
    var callData: Welcome?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        tableView.backgroundColor = UIColor.white
        tableView.separatorColor = UIColor.white
        
        tableView.tableHeaderView?.backgroundColor = UIColor.cyan
        tableView.tableFooterView?.backgroundColor = UIColor.cyan
        
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
                case .success(let callData):
                    completion(.success(callData))
                    
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



class AccessTokenInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else {
            completion(.failure(fatalError()))
        }
        var newRequest = urlRequest
        newRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        completion(.success(newRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if request.response?.statusCode != 401 {
            completion(.doNotRetry)
            return
        }
        
        refreshToken() { s in
            if s {
                completion(.retry)
            } else {
                completion(.doNotRetry)
            }
        }
    }
    
    func refreshToken(completion: (_ success: Bool) -> Void){
        
        
        
        
        
        completion(true)
        
        completion(false)
    }
}
