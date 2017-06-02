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
//  Use image views to move to correct screen.

class NavViewController: UIViewController {
    
    @IBOutlet weak var mapImage: UIImageView!
    let mapTap = UITapGestureRecognizer()
    //  Function that is overloaded to hide the navigation screen.
    
    @IBOutlet weak var carImage: UIImageView!
    let carTap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.navigationItem.setHidesBackButton(true, animated: false)
        mapImage.isUserInteractionEnabled = true
        carImage.isUserInteractionEnabled = true
        mapTap.addTarget(self, action: #selector(NavViewController.mapTapped))
        carTap.addTarget(self, action: #selector(NavViewController.carTapped))
        mapImage.addGestureRecognizer(mapTap)
        carImage.addGestureRecognizer(carTap)
    }// Do any additional setup after loading the view.
    
    func mapTapped() -> Void {
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    func carTapped() -> Void {
        performSegue(withIdentifier: "toAlertMe", sender: nil)
    }
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
