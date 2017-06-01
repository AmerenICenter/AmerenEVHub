//
//  NavViewController.swift
//  Ameren EV Hub
//
//  Created by AmereniCenter4 on 5/26/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import Firebase

//  ViewController for navigation to "maps" and "alert me" views.
//  Allows the user to navigate to different functionalities.
//  Use buttons created in storyboard to navigate (not coded).

class NavViewController: UIViewController {
    
    //  Function that is overloaded to hide the navigation screen.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }// Do any additional setup after loading the view.
    
    //  Function to log out the user and end the session.

    @IBAction func logOut(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try? FIRAuth.auth()?.signOut()
                if FIRAuth.auth()?.currentUser == nil {
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! LoginViewController
                    self.present(loginVC, animated: true, completion: nil)
                }
            }
        }
    }
}
