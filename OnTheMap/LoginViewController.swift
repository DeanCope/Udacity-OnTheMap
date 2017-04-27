//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/6/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import Foundation
import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var keyboardOnScreen = false
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var savePassword: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signUpButton: UIButton!

    var session: URLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = UserDefaults.standard.value(forKey: "email") as? String {
                emailField.text = email
        }
        if let password = UserDefaults.standard.value(forKey: "password") as? String {
            passwordField.text = password
        }
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Actions
    
    @IBAction func signUp(_ sender: Any) {
        if let url = URL(string: UdacityClient.Constants.SignUpURL) {
            UIApplication.shared.open(url)
        } else {
            displayMessage("Cannot open page: \(UdacityClient.Constants.SignUpURL)")
        }
    }
    
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        if emailField.text!.isEmpty || passwordField.text!.isEmpty {
            messageLabel.text = "Please enter an email address and password."
        } else {
            setUIEnabled(false)
            displayMessage("Logging in...")
            UdacityClient.sharedInstance().authenticate(email: emailField.text!, password: passwordField.text!) { (success, error) in
                performUIUpdatesOnMain {
                    if success {
                        self.retrieveStudentLocations()
                    } else {
                        self.setUIEnabled(true)
                        self.displayMessage(error?.description)
                        if let uError = error {
                            switch uError {
                            case UdacityClient.UdacityClientError.invalidIdOrPassword:
                                let alert = UIAlertController(title: "Login error", message: uError.description, preferredStyle: .actionSheet)
                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(alert, animated: true)
                            default:
                                let alert = UIAlertController(title: "Communications error", message: uError.description, preferredStyle: .actionSheet)
                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Login
    
    private func retrieveStudentLocations() {
        
        displayMessage("Getting the student locations...")
        
        ParseClient.sharedInstance().getStudentLocations(100) { (success, error) in
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                if success {
                    self.completeLogin()
                } else {
                    self.displayMessage(error?.description)
                    let alert = UIAlertController(title: "Error Getting Student Locations", message: error?.description, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    private func completeLogin() {
        messageLabel.text = ""
        if savePassword.isOn {
            UserDefaults.standard.setValue(emailField.text, forKey: "email")
            UserDefaults.standard.setValue(passwordField.text, forKey: "password")
        } else {
            UserDefaults.standard.setValue("", forKey: "email")
            UserDefaults.standard.setValue("", forKey: "password")
        }
        performSegue(withIdentifier: "ShowTabs", sender: self)
    }
    

// MARK: - LoginViewController (Configure UI)
    
     func setUIEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        messageLabel.isEnabled = enabled
        emailField.isEnabled = enabled
        passwordField.isEnabled = enabled
        savePassword.isEnabled = enabled
        signUpButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
            activityIndicator.stopAnimating()
        } else {
            loginButton.alpha = 0.5
            activityIndicator.startAnimating()
        }
    }
    
    func displayMessage(_ messageString: String?) {
        if let messageString = messageString {
            messageLabel.text = messageString
        }
    }
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
       let userInfo = (notification as NSNotification).userInfo
       let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
       return keyboardSize.cgRectValue.height / 2
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(emailField)
        resignIfFirstResponder(passwordField)
    }
}
// MARK: - LoginViewController (Notifications)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

