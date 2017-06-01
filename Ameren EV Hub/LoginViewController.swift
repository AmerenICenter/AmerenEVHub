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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //  Function that allows the user to login and authenticate themself.
    
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
                let alert = UIAlertController(title: "Login Failure", message: "Please enter a valid login!", preferredStyle: UIAlertControllerStyle.actionSheet)
                let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(dismiss)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    //  This function is overloaded to hide the navigation screen.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}

