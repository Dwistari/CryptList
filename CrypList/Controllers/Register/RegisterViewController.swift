//
//  RegisterViewController.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.isSecureTextEntry = true
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        registerUser()
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func registerUser() {
        guard let name = nameTF.text, let email = emailTF.text,
              let password = passwordTF.text,
              !name.isEmpty, !email.isEmpty,
              !password.isEmpty else {
            showAlert(message: "Please enter both username and password.")
            return
        }
        
        let success = CoreDataManager.shared.registerUser(name: name, email: email, password: password)
        if success {
            showAlert(message: "Registration successful!", title: "Success")
            let vc = LoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            showAlert(message: "Username already exists.", title: "Failed")
        }
    }
    
    private func showAlert(message: String, title: String = "Alert") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
