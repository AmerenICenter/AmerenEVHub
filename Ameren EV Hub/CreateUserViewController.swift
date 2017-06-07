//
//  CreateUserViewController.swift
//  Ameren EV Hub
//
//  Created by AmereniCenter4 on 5/24/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

//  ViewController for creating a new user.
//  Allows user to create a new user with a password
//  and email. *NOTE* Email is not verified, and therefore
//  not guaranteed to be valid.

class CreateUserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //  Function that creates the user.
    
    @IBAction func createUser(_ sender: Any) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user: FIRUser?, error) in
            if error == nil {
                OperationQueue.main.addOperation {
                    FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user: FIRUser?, error) in
                        if error == nil {
                            //  If there is no error associated with login, print to the console and go the navigation screen.
                            print("Success")
                            self.performSegue(withIdentifier: "goToNavHomeNewUser", sender: nil)
                            
                        }
                    })

                    //self.createWorked()
                }
            } else  {
                OperationQueue.main.addOperation {
                    self.createFailed()
                }
            }
        })
    }
    
    //  Helper function that creates and presents an alert when user creation has failed.
    
    func createFailed() -> Void {
        let alert = UIAlertController(title: "User Creation Failure", message: "Please try again!", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    //  Helper function that creates and presents an alert when user creation has succeeded.
    
    func createWorked() -> Void {
        let alert = UIAlertController(title: "Profile Created", message: "You can now log in!", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
}
    
    // viewDidLoad() is overloaded to hide the navigation screen.
    
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
                createUser(self)
            }
        }
        return false
    }
}
