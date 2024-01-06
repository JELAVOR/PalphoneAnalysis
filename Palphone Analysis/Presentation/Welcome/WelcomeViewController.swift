
import Foundation
import UIKit


class WelcomeViewController: UIViewController {
    var viewModel: WelcomeViewModel!

    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""

        let container = AppDelegate.shared.container
        viewModel = container.resolve(WelcomeViewModel.self)

        viewModel.animateTitle { [weak self] letter in
            guard let self = self else { return }
            self.titleLabel.text?.append(letter)
        }

        if let _ = UserDefaults.standard.string(forKey: "AccessToken") {
            viewModel.navigateToTableView?()
        }
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        viewModel.loginButtonPressed()
    }

    func navigateToTableView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableViewController = storyboard.instantiateViewController(withIdentifier: "DetailsTable") as? ReportViewController else {
            return
        }

        tableViewController.loginService = viewModel.loginService
        navigationController?.pushViewController(tableViewController, animated: true)
    }
}
