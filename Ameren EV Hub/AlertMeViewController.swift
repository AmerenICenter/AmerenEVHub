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

class AlertMeViewController: UIViewController,UIPickerViewDataSource, UITextFieldDelegate, UIPickerViewDelegate {
    
    var ref: FIRDatabaseReference!
//    @IBOutlet weak var EVSEForMe: UITextField!
    var EVSEForMe: String = ""
    var isInUseFlag = false
    var refHandle : UInt = 0
    
////////////////////////////////////////////////////////////////////////
    
////////////////////////////////////////////////////////////////////////
//  This is deleted at last working interval
    @IBOutlet weak var dropDown: UIPickerView!
    
    var names = ["parkingSpot1", "parkingSpot2", "parkingSpot3"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return names.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return names[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.EVSEForMe = self.names[row]
       // self.dropDown.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dropDown.isHidden = false
    }
    
    
    
///////////////////////////////////////////////////////////////////////////
    
    
    //  Function that creates/ends the alert for the user.
    
    @IBAction func addToAlert(_ sender: Any) {
        if !isInUseFlag && (EVSEForMe != "") {
            isInUseFlag = true
            refHandle = self.ref.child("EVApp/EVAppData").child(EVSEForMe).observe(FIRDataEventType.value, with: { snap in
                let state = String(describing: snap.childSnapshot(forPath: "EVSEState").valueInExportFormat()!)
                if (state == "4") {
                    //  If the car has charged then stop checking it and call the helper function.
                    print("Car is done charging please move it!")
                    self.ref.child("EVApp/EVAppData").child(self.EVSEForMe).removeObserver(withHandle: self.refHandle)
                    self.carIsCharged()
                }
                else {
                    print("Car is still charging!")
                }
            })
        } else if EVSEForMe == "" {
            print("Please enter a valid ID")
        } else {
            onlyOneCar()
        }
    }
    
    //  This function removes the observer from the car. 
    
    @IBAction func removeCar(_ sender: Any) {
        if isInUseFlag {
            print("Car is removed from alert me system!")
            self.ref.child("EVApp/EVAppData").child(self.EVSEForMe).removeObserver(withHandle: self.refHandle)
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
    
    //  Helper function that presents an alert when the user attempts to register more
    //  than one charger.
    
    func onlyOneCar() -> Void {
        let alert = UIAlertController(title: "Warning", message: "You can only register one charger at a time!", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    //  Helper function that presents an alert to the user telling them that their car has charged.
    
    func carIsCharged() -> Void {
        let alert = UIAlertController(title: "Car Charged!", message: "Please move your car out!", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        isInUseFlag = false
    }
    
    //  Overloaded function that sets up the path for the database.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
    }// Do any additional setup after loading the view.
    
}
