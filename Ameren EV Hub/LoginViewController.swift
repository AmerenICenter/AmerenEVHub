//
//  LoginViewController.swift
//  Ameren EV Hub
//
//  Created by AmereniCenter4 on 5/24/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

//  ViewController for logging in.
//  Allows user to log in to the application
//  if they have their email and password.

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //  Function that allows the user to login and authenticate themself
    
    @IBAction func loginUser(_ sender: Any) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user: FIRUser?, error) in
            if error == nil {
                //  If there is no error associated with login, print to the console and go the navigation screen.
                print("Success")
                self.performSegue(withIdentifier: "goToNavHome", sender: nil)
                
            } else {
                //  If there is a problem with logging in, present an error message with an OK button.
                let alert = UIAlertController(title: "Login Failure", message: "Please enter a valid login!", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(dismiss)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: - Overridden Parent Functions
    
    //  This function is overloaded to hide the navigation screen.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        emailTextField.returnKeyType = UIReturnKeyType.next
        emailTextField.textAlignment = NSTextAlignment.center
        emailTextField.delegate = self
        passwordTextField.returnKeyType = UIReturnKeyType.go
        passwordTextField.textAlignment = NSTextAlignment.center
        passwordTextField.delegate = self
    }

    // MARK: - Outlet Functions

    @IBAction func dismissKeyboard(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate Functions
    
    // ----------------------------------------------------------------
    // textFieldShouldReturn - specifies text field behavior on return
    //                         key, in this case, navigating from email
    //                         view to text view to login
    // @return - false, indicating text field should not execute
    //           default behavior
    // ----------------------------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text != nil && textField.text!.characters.count > 0) {
            if (textField == emailTextField) {
                passwordTextField.becomeFirstResponder()
            } else {
                loginUser(self)
            }
        }
        return false
    }
}

