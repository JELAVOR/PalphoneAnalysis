import UIKit
import Alamofire

enum AuthError: Error {
    case jwtExpired
}

class CallDataTableViewCell: UITableViewCell {
    @IBOutlet weak var talkIdLabel: UILabel!
    @IBOutlet weak var languageIdLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    static let identifier = "CallDataCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
enum CustomError:Error{
    case NoAccount
}

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
        guard let token = UserDefaults.standard.string(forKey: "RefreshToken") else {
            completion(false)
            return
        }

        let refreshTokenURL = "https://boapi.palphone.com/user/token"
        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        var headers =  HTTPHeaders()
        headers.add(header)

        AF.request(refreshTokenURL, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Aliz2.self) { response in
                switch response.result {
                case .success(let newTokens):
                    UserDefaults.standard.set(newTokens.tokens.accessToken, forKey: "AccessToken")
                    UserDefaults.standard.set(newTokens.tokens.refreshToken, forKey: "RefreshToken")
                    completion(true)

                case .failure(let error):
                    print("Token refresh failed. Error: \(error.localizedDescription)")
                    completion(false)
                }
            }
    }
}


//MARK: Table View
class YourTableViewController: UITableViewController {
    var callData: Welcome?
    var currentPage = 1
    var totalRecords = 0
    @IBOutlet var alirezaTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        fetchCallDataReports(page:2)
        setupTableView()
        UserDefaults.standard.set("invalid_token", forKey: "AccessToken")
        alirezaTable?.translatesAutoresizingMaskIntoConstraints = false
        alirezaTable.register(CallDataTableViewCell.self, forCellReuseIdentifier: CallDataTableViewCell.identifier)

        self.alirezaTable.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.alirezaTable.reloadData()
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
           // Disable scrolling by resetting the content offset to zero
           scrollView.contentOffset = CGPoint(x: 0, y: 0)
       }
    
    @IBAction func logOutPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Private Methods
    private func setupTableView() {
//        tableView.backgroundColor = UIColor.cyan
//        tableView.separatorColor = UIColor.white
//        tableView.tableHeaderView?.backgroundColor = UIColor.cyan
//        tableView.tableFooterView?.backgroundColor = UIColor.cyan
//        
        
        self.alirezaTable.delegate = self
        self.alirezaTable.dataSource = self

        // Register the XIB file
//        let nib = UINib(nibName: "CallDataTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: CallDataTableViewCell.identifier)
   

    }

    // MARK: - Networking
    private func fetchData(with jwt: String, page: Int, from url: URL, completion: @escaping (Result<Welcome, Error>) -> Void) {
        var request = URLRequest(url: url)
        let interceptor = AccessTokenInterceptor()
        let parameters: [String: Any] = ["page": page]

        AF.request(url, parameters: parameters, interceptor: interceptor)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Welcome.self) { response in
                switch response.result {
                case .success(let responseData):
                    completion(.success(responseData))
                    self.callData = responseData

                    // Assuming your meta data has a total count
                    self.totalRecords = responseData.meta.total

                    DispatchQueue.main.async {
                        self.alirezaTable.reloadData()
                    }

                    print("Call data fetched successfully +++++++ totalRecords: \(self.totalRecords)")

                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 401 {
                        completion(.failure(AuthError.jwtExpired))
                    } else {
                        completion(.failure(error))
                    }

                    if let data = response.data {
                        let responseString = String(data: data, encoding: .utf8)
                        self.callData = response.value
                        self.alirezaTable.reloadData()

                        print("Response String: \(responseString ?? "Unable to convert data to string") ++++ \(data) +++ \(response.value) \(response)")
                    }
                }
            }
    }


    private func fetchCallDataReports(page: Int) {
        
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height

            if offsetY > contentHeight - scrollView.frame.height {
                // Load more data when reaching the end
                currentPage += 1
                fetchCallDataReports(page: currentPage)
            }
        }

        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else {
            return
        }

        let urlString = "https://boapi.palphone.com/admin/reports/talks?from=2023-05-07T08%3A00%3A00Z&to=2023-05-07T08%3A59%3A59Z"

        guard let url = URL(string: urlString) else {
            return
        }

        fetchData(with: accessToken, page: page, from: url) { result in
            switch result {
            case .success(let callData):
                self.callData = callData
                self.totalRecords = callData.meta.total
                DispatchQueue.main.async {
                    self.alirezaTable.reloadData()
                }

                // Accessing and recognizing the fetched data
                for talk in callData.data {
                    print("Talk ID: \(talk.talkId), Language ID: \(talk.languageId), Duration: \(talk.duration), Status: \(talk.status)")

                    // Accessing pals for each talk
                    for pal in talk.pals {
                        print("Pal - Account ID: \(pal.accountId), Character ID: \(pal.characterId), Country: \(pal.country)")
                    }
                }

                print("Call data fetched successfully")

            case .failure(let error):
                switch error {
                case AuthError.jwtExpired:
                    print("JWT expired. Please log in again.")
                default:
                    print("Failed to fetch call data. Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension YourTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Safely unwrap callData and its data property
        var rowCount = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
           rowCount = self.callData?.data.count ?? 0
            print("Number of Rows: \(rowCount) +++ \(self.callData?.data)")
        }
        return rowCount
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .palphonePink
        view.frame = CGRect(x: 10, y: 60, width: 100, height: 60)
        return view
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // MARK: - UITableViewDataSource
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return callData?.data.count ?? 0
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("hashemi talkesh in \(callData?.data[safe: indexPath.row] )")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CallDataTableViewCell.identifier, for: indexPath) as? CallDataTableViewCell else {
            print("Unable to dequeue CallDataTableViewCell for indexPath: \(indexPath)")
            return UITableViewCell()
        }

        print("Configuring cell for Talk ID: \(indexPath.row) \(callData?.data[indexPath.row])")
        if let talk = callData?.data[safe: indexPath.row] {
            print("Configuring cell for Talk ID: \(talk.talkId)")
            cell.talkIdLabel.text = "Talk ID: \(talk.talkId)"
            cell.languageIdLabel.text = "Language ID: \(talk.languageId)"
            cell.durationLabel.text = "Duration: \(talk.duration)"
            cell.statusLabel.text = "Status: \(talk.status)"
            // Assuming you have a loop that iterates through talk.pals
            for pal in talk.pals {
                let accountID = pal.accountId
                let characterID = pal.characterId
                let country = pal.country
                print("Pal - Account ID: \(accountID), Character ID: \(characterID), Country: \(country)")
                self.alirezaTable.reloadData()
            }
        }

        return cell
    }



}

// Extension to safely access array elements by index
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
