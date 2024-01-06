import UIKit
import Alamofire
import Swinject


class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var loginService: LoginService!
    var apiRequest: APIRequest!
    let appDelegate = AppDelegate.shared

    @IBOutlet weak var detailsTableView: UITableView!
    var callData: Welcome?
    var isFetchingData = false
    private var loadingView: UIView?
    var currentPage = 1
    var totalRecords = 0
    var loadingIndicatorView: UIActivityIndicatorView?
    private let userDefault = AppUserDefaults()
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupLoadingView()
        
        apiRequest = appDelegate.container.resolve(APIRequest.self)
        
            fetchCallDataReports(page: 2)
            detailsTableView.delegate = self
            detailsTableView.dataSource = self
            setupLoadingIndicator()
            navigationItem.hidesBackButton = true
        }
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        userDefault.removeTokens()
        navigationController?.popToRootViewController(animated: true)

    }
    
    
    private func showLoadingView() {
            loadingView?.isHidden = false
        }

        private func hideLoadingView() {
            loadingView?.isHidden = true
        }
    
    private func setupLoadingView() {
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: detailsTableView.bounds.width, height: detailsTableView.bounds.height))
        loadingView?.backgroundColor = .white
        
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.center = loadingView?.center ?? CGPoint.zero
        activityIndicator.startAnimating()
        
        loadingView?.addSubview(activityIndicator)
        detailsTableView.addSubview(loadingView!)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.callData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as? ReportTableViewCell else {
            fatalError("Failed to dequeue a valid ReportTableViewCell.")
        }
        
        for talk in self.callData!.data {
            // Accessing pals for each talk
            for _ in talk.pals {
                let dataForCell = callData?.data[indexPath.row]
                cell.accountId.text = "\(dataForCell!.talkId)"
                cell.countryLabel.text = "\(getLanguageString(from: dataForCell!.languageId))"
                let formattedDuration = formatDuration(seconds: dataForCell!.duration)
                cell.durationLabel.text = "\(formattedDuration)"
                cell.statusLabel.text = "\(getStatusString(from: dataForCell!.status))"
            }
        }
        return cell
    }
    
    private func setupLoadingIndicator() {
        loadingIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        loadingIndicatorView?.frame = CGRect(x: 0, y: 0, width: detailsTableView.bounds.width, height: 44)
        loadingIndicatorView?.hidesWhenStopped = true
        detailsTableView.tableFooterView = loadingIndicatorView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height, !isFetchingData {
            // Load more data when reaching the end
            currentPage += 1
            fetchCallDataReports(page: currentPage)
            loadingIndicatorView?.startAnimating() // Show loading indicator
        }
    }
    
    private func fetchData(with jwt: String, page: Int, from url: URL, completion: @escaping (Result<Welcome, Error>) -> Void) {
//        let request = URLRequest(url: url)
        let interceptor = AccessTokenInterceptor()
        let parameters: [String: Any] = ["page": page]
        
        AF.request(url, parameters: parameters, interceptor: interceptor)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Welcome.self) { response in
                switch response.result {
                case .success(let responseData):
                    completion(.success(responseData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    private func fetchCallDataReports(page: Int) {
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else {
            return
        }
        showLoadingView()
        let urlString = "https://boapi.palphone.com/admin/reports/talks?from=2023-05-07T08%3A00%3A00Z&to=2023-05-07T08%3A59%3A59Z&limit=100"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        isFetchingData = true
        
        fetchData(with: accessToken, page: page, from: url) { [weak self] result in
            guard let self = self else { return }
            
            defer {
                self.hideLoadingView()  // Hide loading indicator
                self.isFetchingData = false
                           }
            
            switch result {
            case .success(let newCallData):
                if self.callData == nil {
                    self.callData = Welcome(data: [], meta: Meta(total: 0, perPage: 0, currentPage: 0, lastPage: 0))
                }
                
                if var existingData = self.callData?.data {
                    existingData.append(contentsOf: newCallData.data)
                    self.callData?.data = existingData
                } else {
                    self.callData = newCallData
                }
                
                self.totalRecords = newCallData.meta.total
                
                DispatchQueue.main.async {
                    self.detailsTableView.reloadData()
                    self.loadingIndicatorView?.stopAnimating()
                }
                
                for talk in self.callData?.data ?? [] {
                    print("Talk ID: \(talk.talkId), Language ID: \(talk.languageId), Duration: \(talk.duration), Status: \(talk.status)")
                    
                    // Accessing pals for each talk
                    for pal in talk.pals {
                        print("Pal - Account ID: \(pal.accountId), Character ID: \(pal.characterId), Country: \(pal.country)")
                    }
                }
                
                print("Call data fetched successfully")
                print("Number of rows : \(self.callData?.data.count ?? 0)")
                
            case .failure(let error):
                switch error {
                case AuthError.jwtExpired:
                    print("JWT expired. Please log in again.")
                default:
                    print("Failed to fetch call data. Error: \(error.localizedDescription)")
                }
                self.loadingIndicatorView?.stopAnimating() // Hide loading indicator
            }
        }
        
    }
    
    private func getStatusString(from status: Int) -> String {
        switch status {
        case 1: return "Not Started"
        case 2: return "In Progress"
        case 3: return "Finished"
        case 4: return "Exited"
        case 5: return "Wait Call"
        case 6: return "Reject Call"
        case 7: return "Missed Call"
        case 8: return "Cancel Call"
        case 9: return "Calling"
        case 10: return "Ringing"
        case 11: return "Cancel Ring"
        case 12: return "Pal Not Found"
        case 13: return "Firebase Error"
        case 14: return "Token Not Found"
        case 15: return "Blocked by Pal"
        case 16: return "Deleted Pal"
        case 17: return "Receiving Notification"
        case 18: return "Busy"
   
        default: return "Unknown"
        }
    }
    
    private func getLanguageString(from languageId: Int) -> String {
        switch languageId {
        case 1: return "English"
        case 2: return "Spanish"
        case 3: return "Arabic"
        case 4: return "Persian"
        case 5: return "French"
        case 6: return "Portuguese"
        case 7: return "Deutsch"
        case 8: return "Italian"
        case 9: return "Chinese"
        case 10: return "Indian"
        case 11: return "Russian"
        case 12: return "Turkish"
        case 13: return "Ordu"
        case 14: return "Algerian"
        default: return "Unknown"
        }
    }
}

private func formatDuration(seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let remainingSeconds = seconds % 60
    let formattedDuration = String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    return formattedDuration
}
