


import UIKit

class NavigationUtility {
    static func navigateToTableView(from WelcomeViewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableViewController = storyboard.instantiateViewController(withIdentifier: "DetailsTable") as? ReportViewController else {
            return
        }
        
        WelcomeViewController.navigationController?.pushViewController(tableViewController, animated: true)
    }
}
