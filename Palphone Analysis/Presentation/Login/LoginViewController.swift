
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    private var loginService: LoginService!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginService = LoginService()
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        loginButton.isEnabled = false
        loginButton.setTitle("Logging In...", for: .normal)

        loginService.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }

            self.loginButton.isEnabled = true
            self.loginButton.setTitle("Login", for: .normal)

            switch result {
            case .success(let aliz):
             
                AppUserDefaults().accessToken = aliz.tokens.accessToken
                AppUserDefaults().refreshToken = aliz.tokens.accessToken
    
                NavigationUtility.navigateToTableView(from: self)

            case .failure(let error):
                print("Login failed. Error: \(error.localizedDescription)")

                let alert = UIAlertController(title: "Login Failed", message: "Incorrect email or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
