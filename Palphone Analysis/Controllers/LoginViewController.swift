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
        
        loginButton.isEnabled = false
        
        loginButton.setTitle("Logging In...", for: .normal)
        
        login(email: email, password: password) { result in
            self.loginButton.isEnabled = true
            
            self.loginButton.setTitle("Login", for: .normal)
            
            switch result {
            case .success(let aliz):
                UserDefaults.standard.set(aliz.tokens.accessToken, forKey: "AccessToken")
                UserDefaults.standard.set(aliz.tokens.refreshToken, forKey: "RefreshToken")
                NavigationUtility.navigateToTableView(from: self)
                
            case .failure(let error):
                print("Login failed. Error: \(error.localizedDescription)")
                
                let alert = UIAlertController(title: "Login Failed", message: "Incorrect email or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    struct LoginRequest: Encodable {
        let email: String
        let password: String
    }
    func login(email: String, password: String, completion: @escaping (Result<Aliz, Error>) -> Void) {
        let baseUrl = "https://boapi.palphone.com"
        let loginURL = baseUrl + "/v1/login"
        
        let loginData = LoginRequest(email: email, password: password)
        
        AF.request(loginURL, method: .post, parameters: loginData, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Aliz.self) { response in
                switch response.result {
                case .success(let aliz):
                    UserDefaults.standard.set(aliz.tokens.accessToken, forKey: "AccessToken")
                    UserDefaults.standard.set(aliz.tokens.refreshToken, forKey: "RefreshToken")
                    completion(.success(aliz))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
