//
//  LoginViewController.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.isSecureTextEntry = true
    }


    @IBAction func loginBtn(_ sender: Any) {
        guard let email = emailTF.text,
              let password = passwordTF.text else { return }
        
        if CoreDataManager.shared.loginUser(email: email, password: password) != nil {
            let vc = HomeViewController()
            navigationController?.pushViewController(vc, animated: true)
            SessionManager.shared.login(email: email)
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
