//
//  ResetPasswordViewController.swift
//  Ameren EV Hub
//
//  Created by AmereniCenter4 on 5/24/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func resetPassword(_ sender: Any) {
        let email = emailTextField.text
        FIRAuth.auth()?.sendPasswordReset(withEmail: email!) { error in
            if error == nil {
                print("Success")
            } else  {
                print("failure")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }}
