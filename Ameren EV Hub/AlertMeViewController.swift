//
//  AlertMeViewController.swift
//  Ameren EV Hub
//
//  Created by AmereniCenter4 on 5/26/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

//  ViewController for setting up car charging reminder.
//  Allows user to register a car to a car charging port
//  and alerts them when the car is done charging.

class AlertMeViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    @IBOutlet weak var EVSEForMe: UITextField!
    var isInUseFlag = false
    var refHandle : UInt = 0
    
    //  Function that creates/ends the alert for the user.
    
    @IBAction func addToAlert(_ sender: Any) {
        if !isInUseFlag && (EVSEForMe.text != "") {
            isInUseFlag = true
//            refHandle : UInt = 0
            refHandle = self.ref.child("EVApp/EVAppData").child(EVSEForMe.text!).observe(FIRDataEventType.value, with: { snap in
                let state = String(describing: snap.childSnapshot(forPath: "EVSEState").valueInExportFormat()!)
                if (state == "4") {
                    //  If the car has charged then stop checking it and call the helper function.
                    print("Car is done charging please move it!")
                    self.ref.child("EVApp/EVAppData").child(self.EVSEForMe.text!).removeObserver(withHandle: self.refHandle)
                    self.carIsCharged()
                }
                else {
                    print("Car is still charging!")
                }
            })
        } else if EVSEForMe.text == "" {
            print("Please enter a valid ID")
        } else
        {
            onlyOneCar()
        }
        
    }
    
    
    @IBAction func removeCar(_ sender: Any) {
        if isInUseFlag {
            print("Car is removed from alert me system!")
            self.ref.child("EVApp/EVAppData").child(self.EVSEForMe.text!).removeObserver(withHandle: self.refHandle)
            isInUseFlag = false
        } else {
            print("Nothing interesting happens")
        }
    }

    
    //  Allows the user to log out.
    
    @IBAction func logMeOut(_ sender: Any) {
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
    
    func onlyOneCar() -> Void {
        let alert = UIAlertController(title: "Warning", message: "You can only register one charger at a time!", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    //  Helper function that presents an alert to the user telling them that their car has charged.
    
    func carIsCharged() -> Void {
        let alert = UIAlertController(title: "Car Charged!", message: "Please move your car out!", preferredStyle: UIAlertControllerStyle.actionSheet)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        isInUseFlag = false
    }
    
    func carIsChargedSMS() -> Void {
        isInUseFlag = false
    }
    
    //  Overloaded function that sets up the path for the database.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
    }// Do any additional setup after loading the view.
    
}
