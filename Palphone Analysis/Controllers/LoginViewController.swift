import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        // Disable the login button to prevent multiple taps
        loginButton.isEnabled = false

        // Change the text on the login button to indicate loading
        loginButton.setTitle("Logging In...", for: .normal)

        login(email: email, password: password) { result in
            // Re-enable the login button
            self.loginButton.isEnabled = true

            // Change the text on the login button back to the original
            self.loginButton.setTitle("Login", for: .normal)

            switch result {
            case .success(let aliz):
                UserDefaults.standard.set(aliz.tokens.accessToken, forKey: "AccessToken")
//                let pascalCase = 10
                // Handle successful login, e.g., store user session information

                // Perform the segue only when the login is successful
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "reportsViewController") {
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                print("Login successful. Access Token: \(aliz.tokens.accessToken)")

            case .failure(let error):
                // Handle login failure, show an error message, etc.
                print("Login failed. Error: \(error.localizedDescription)")

                // Display an alert to the user
                let alert = UIAlertController(title: "Login Failed", message: "Incorrect email or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
//
//class BaseClass{
//    static let B_Url = "http://palphone.com"
//    static var tocken = "http://palphone.com"
//}
//
//class Ali{
//    init(name: String) {
//        self.name = name
//    }
//    var name: String = ""
//}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
func login(email: String, password: String, completion: @escaping (Result<Aliz, Error>) -> Void) {
    let loginURL = "https://boapi.palphone.com/v1/login"

    let loginData = LoginRequest(email: email, password: password)

    AF.request(loginURL, method: .post, parameters: loginData, encoder: JSONParameterEncoder.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Aliz.self) { response in
            switch response.result {
            case .success(let aliz):
                // Update the access token in UserDefaults
                UserDefaults.standard.set(aliz.tokens.accessToken, forKey: "AccessToken")
                completion(.success(aliz))
            case .failure(let error):
                completion(.failure(error))
            }
        }
}
