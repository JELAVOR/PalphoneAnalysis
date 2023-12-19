import UIKit
import Alamofire

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var detailsTableView: UITableView!
    var callData: Welcome?
    var isFetchingData = false
    private var loadingView: UIView?
    var currentPage = 1
    var totalRecords = 0
    var loadingIndicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
           super.viewDidLoad()
           setupNavigationBar()
           setupLoadingView()
           fetchCallDataReports(page: 2)
           detailsTableView.delegate = self
           detailsTableView.dataSource = self
           setupLoadingIndicator()
       }
    
    private func showLoadingView() {
            loadingView?.isHidden = false
        }

        private func hideLoadingView() {
            loadingView?.isHidden = true
        }
    private func setupNavigationBar() {
           // Create a separator view
           let separatorView = UIView()
           separatorView.backgroundColor = .lightGray  // Adjust the color as needed

           // Add the separator view as a subview to the navigation bar
           if let navigationBar = self.navigationController?.navigationBar {
               navigationBar.addSubview(separatorView)

               // Set up constraints for the separator view
               separatorView.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   separatorView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
                   separatorView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
                   separatorView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
                   separatorView.heightAnchor.constraint(equalToConstant: 1)  // Adjust the height as needed
               ])
           }
       }
    private func setupLoadingView() {
            loadingView = UIView(frame: CGRect(x: 0, y: 0, width: detailsTableView.bounds.width, height: detailsTableView.bounds.height))
            loadingView?.backgroundColor = .white  // Adjust the color as needed

            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.center = loadingView?.center ?? CGPoint.zero
            activityIndicator.startAnimating()

            loadingView?.addSubview(activityIndicator)
            detailsTableView.addSubview(loadingView!)
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.callData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as? DetailsCostumCellTableViewCell else {
            fatalError("Failed to dequeue a valid DetailsCostumCellTableViewCell.")
        }
        
        for talk in self.callData!.data {
            // Accessing pals for each talk
            for pal in talk.pals {
                var dataForCell = callData?.data[indexPath.row]
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
        loadingIndicatorView = UIActivityIndicatorView(style: .gray)
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
        var request = URLRequest(url: url)
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
                    self.loadingIndicatorView?.stopAnimating() // Hide loading indicator
                }
                // Accessing and recognizing the fetched data
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
        case 1: return "not started"
        case 2: return "in progress"
        case 3: return "finished"
        case 4: return "exited"
        case 5: return "wait call"
        case 6: return "reject call"
        case 7: return "missed call"
        case 8: return "cancel call"
        case 9: return "calling"
        case 10: return "ringing"
        case 11: return "cancel ring"
        case 12: return "pal not found"
        case 13: return "firebase error"
        case 14: return "token not found"
        case 15: return "blocked by pal"
        case 16: return "deleted pal"
        case 17: return "receiving notification"
        case 18: return "busy"
   
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

