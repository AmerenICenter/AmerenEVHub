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

class CreateUserViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //  Function that creates the user.
    
    @IBAction func createUser(_ sender: Any) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user: FIRUser?, error) in
            if error == nil {
                OperationQueue.main.addOperation {
                    self.createWorked()
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
    }
}
