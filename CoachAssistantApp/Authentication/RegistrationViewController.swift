//
//  RegistrationViewController.swift
//  CoachAssistantApp
//
//  Created by Dimitar Parapanov on 20.02.20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextView: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = AuthenticationConstants.buttonCornerRadius
        cancelButton.superview?.layer.borderWidth = 2
        cancelButton.superview?.layer.borderColor = UIColor(named: "PrimaryColor")!.cgColor
        cancelButton.superview?.layer.cornerRadius = 10
        let hideKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(hideKeyboardGestureRecognizer)
    }
    
    // MARK: - Actions
    @IBAction func onTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapRegister(_ sender: Any) {
        guard let username = emailTextField.text,
            let firstPassword = passwordTextField.text,
            let secondPassword = confirmPasswordTextView.text
        else {
            return
        }
        
        if firstPassword.count < AuthenticationConstants.maximumPasswordLength || secondPassword.count < AuthenticationConstants.maximumPasswordLength {
            present(UIAlertController.createDefaultAlert(title: "Invalid password!", message: "Your password should be at least \(AuthenticationConstants.maximumPasswordLength) characters long."), animated: true, completion: nil)
            return
        }
        
        if firstPassword != secondPassword {
            present(UIAlertController.createDefaultAlert(title: "Passwords do not match!", message: "Your passwords are not the same. Please re-enter."), animated: true, completion: nil)
            return
        }
        
        Networking.shared.registerUser(useremail: username, password: firstPassword) { [weak self] success in
            guard let self = self else { return }
            guard success else {
                self.present(UIAlertController.createDefaultAlert(title: "Error ❌", message: "Connection to server unsuccessful."), animated: true, completion: nil)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextView.resignFirstResponder()
    }
}
