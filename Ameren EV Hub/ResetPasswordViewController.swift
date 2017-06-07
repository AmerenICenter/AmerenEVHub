//
//  ResetPasswordViewController.swift
//  Ameren EV Hub
//
//  Created by AmereniCenter4 on 5/24/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import Firebase

//  ViewController for password reset view.
//  Allows user to send an email to themselves to reset their password
//  depending on if the email is valid. Presents a message depending on
//  whether the reset attempt was succesful or not.

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    // Function to reset the password.
    
    @IBAction func resetPassword(_ sender: Any) {
        let email = emailTextField.text
        FIRAuth.auth()?.sendPasswordReset(withEmail: email!) { error in
            if error == nil {
                //  Needed an OperationQueue to handle "threading" error.
                OperationQueue.main.addOperation {
                    self.resetWorked()
                }
            } else  {
                //  Needed an OperationQueue to handle "threading" error.
                OperationQueue.main.addOperation {
                    self.resetFailed()
                }
            }
        }
    }
    
    //  Helper function that creates and presents an alert on a successful reset.
    
    func resetWorked() -> Void {
        let alert = UIAlertController(title: "Reset Succeeded", message: "Check your email to reset your password!", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    //  Helper function that creates and presents an alert on failure to reset.
    
    func resetFailed() -> Void {
        let alert = UIAlertController(title: "Reset Failure", message: "Please enter a valid email!", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Overload the function to hide the navigation screen.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        emailTextField.returnKeyType = UIReturnKeyType.go
        emailTextField.textAlignment = NSTextAlignment.center
        emailTextField.delegate = self
    }
    
    // MARK: - Outlet Functions
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        emailTextField.resignFirstResponder()
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
            resetPassword(self)
        }
        return false
    }
}
