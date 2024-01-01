import UIKit
import Alamofire
import Swinject

class WelcomeViewController: UIViewController {

    var loginService: LoginService!
    let appDelegate = AppDelegate.shared

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
        // Resolve dependencies when the login button is pressed
        loginService = appDelegate.container.resolve(LoginService.self)
        let accessToken = AppUserDefaults().accessToken

        NavigationUtility.navigateToTableView(from: self)
    }

    private func navigateToTableView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableViewController = storyboard.instantiateViewController(withIdentifier: "DetailsTable") as? ReportViewController else {
            return
        }

        // Set dependencies before navigating
        tableViewController.loginService = loginService
      

        navigationController?.pushViewController(tableViewController, animated: true)
    }
}
