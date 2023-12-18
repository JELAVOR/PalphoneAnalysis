//
//  DetailsViewController.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/18/23.
//

import UIKit
import Alamofire

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var detailsTableView: UITableView!
    var callData: Welcome?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCallDataReports()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [self] in
            detailsTableView.delegate = self
            detailsTableView.dataSource = self
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callData?.data.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as? DetailsCostumCellTableViewCell else {
            fatalError("Failed to dequeue a valid DetailsCostumCellTableViewCell.")
        }
        
        for talk in self.callData!.data {
            print("Talk ID: \(talk.talkId), Language ID: \(talk.languageId), Duration: \(talk.duration), Status: \(talk.status)")
            
            // Accessing pals for each talk
            for pal in talk.pals {
                print("Pal - Account ID: \(pal.accountId), Character ID: \(pal.characterId), Country: \(pal.country)")
                var dataForCell = callData?.data[indexPath.row]
                cell.accountId.text = "\(dataForCell!.talkId)"
                cell.countryLabel.text = "\(pal.country)"
                cell.durationLabel.text = "\(dataForCell!.duration)"
                cell.statusLabel.text = "\(dataForCell!.status)"
            }
        }
        return cell
    }
    
    private func fetchData(with jwt: String, from url: URL, completion: @escaping (Result<Welcome, Error>) -> Void) {
        var request = URLRequest(url: url)
        let interceptor = AccessTokenInterceptor()
        
        AF.request(request, interceptor: interceptor)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Welcome.self) { response in
                switch response.result {
                case .success(let responseData):
                    completion(.success(responseData))
                    self.callData = responseData
                    
                    DispatchQueue.main.async {
                        self.detailsTableView.reloadData()
                    }
                    
                    print("Call data fetched successfully")
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 401 {
                        completion(.failure(AuthError.jwtExpired))
                    } else {
                        completion(.failure(error))
                    }
                    
                    if let data = response.data {
                        let responseString = String(data: data, encoding: .utf8)
                        self.callData = response.value
                        self.detailsTableView.reloadData()
                        
                        print("Response String: \(responseString ?? "Unable to convert data to string") ++++ \(data) +++ \(response.value) \(response)")
                    }
                }
            }
    }
    
    private func fetchCallDataReports() {
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else {
            return
        }
        
        let urlString = "https://boapi.palphone.com/admin/reports/talks?from=2023-05-07T08%3A00%3A00Z&to=2023-05-07T08%3A59%3A59Z"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        fetchData(with: accessToken, from: url) { result in
            switch result {
            case .success(let callData):
                self.callData = callData
                print("Call data fetched successfully")
                
                DispatchQueue.main.async {
                    self.detailsTableView.reloadData()
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
