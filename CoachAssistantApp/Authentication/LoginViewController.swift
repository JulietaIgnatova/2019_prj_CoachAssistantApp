//
//  LoginViewController.swift
//  CoachAssistantApp
//
//  Created by Yalishanda on 19.02.20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    // MARK: - Properties
    private let showMenuSegueId = "showMenuSegue"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = AuthenticationConstants.buttonCornerRadius
        registrationButton.layer.cornerRadius = AuthenticationConstants.buttonCornerRadius
        let hideKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(hideKeyboardGestureRecognizer)
    }
    
    // MARK: - Actions
    @IBAction func onTapLoginButton(_ sender: UIButton) {
        guard let username = emailField.text, let password = passwordField.text else {
            let alertController = UIAlertController(title: "Password missing!", message: "Please enter a password.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if password.count < AuthenticationConstants.maximumPasswordLength {
            present(UIAlertController.createDefaultAlert(title: "Invalid password!", message: "Your password should be at least \(AuthenticationConstants.maximumPasswordLength) characters long."), animated: true, completion: nil)
            return
        }
        
        Networking.shared.loginUser(useremail: username, password: password) { [weak self] success in
            guard let self = self else { return }
            guard success else {
                self.present(UIAlertController.createDefaultAlert(title: "Error ❌", message: "Connection to server unsuccessful or wrong username or password."), animated: true, completion: nil)
                return
            }
            self.performSegue(withIdentifier: self.showMenuSegueId, sender: self)
        }
    }
    
    // MARK: - Helpers
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}
