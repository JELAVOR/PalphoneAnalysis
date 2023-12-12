import UIKit
import Alamofire


class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""

        var charIndex = 0.0
        let titleText = "Palphone Analysis"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }            // Check if the access token exists in UserDefaults
            if let _ = UserDefaults.standard.string(forKey: "AccessToken") {
                // Access token exists, navigate to the table view directly
                navigateToTableView()
            }
        }
        
    @IBAction func loginButtonPressed(_ sender: UIButton) {
            // Perform your login process and obtain the access token
            
            // For demonstration purposes, assume the login is successful and an access token is obtained
            let accessToken = "AccessToken"
            
            // Save the access token in UserDefaults
            UserDefaults.standard.set(accessToken, forKey: "AccessToken")
            
            // Navigate to the table view
        NavigationUtility.navigateToTableView(from: self)
        }
        
    private func navigateToTableView() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           guard let tableViewController = storyboard.instantiateViewController(withIdentifier: "reportsViewController") as? YourTableViewController else {
               return
           }

           navigationController?.pushViewController(tableViewController, animated: true)
       }
   }


class NavigationUtility {
    static func navigateToTableView(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableViewController = storyboard.instantiateViewController(withIdentifier: "reportsViewController") as? YourTableViewController else {
            return
        }

        viewController.navigationController?.pushViewController(tableViewController, animated: true)
    }
}
