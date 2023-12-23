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
        }            
        if let _ = UserDefaults.standard.string(forKey: "AccessToken") {
            navigateToTableView()
        }
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let accessToken = "AccessToken"
        
        UserDefaults.standard.set(accessToken, forKey: "AccessToken")
        
        NavigationUtility.navigateToTableView(from: self)
    }
    
    private func navigateToTableView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableViewController = storyboard.instantiateViewController(withIdentifier: "DetailsTable") as? DetailsViewController else {
            return
        }
        
        navigationController?.pushViewController(tableViewController, animated: true)
    }
}


class NavigationUtility {
    static func navigateToTableView(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableViewController = storyboard.instantiateViewController(withIdentifier: "DetailsTable") as? DetailsViewController else {
            return
        }
        
        viewController.navigationController?.pushViewController(tableViewController, animated: true)
    }
}
