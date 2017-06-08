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

class AlertMeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var ref: FIRDatabaseReference!
    var EVSEForMe: String = ""
    var isInUseFlag = false
    var refHandle : UInt = 0
    @IBOutlet weak var timerImage: UILabel!
    
    var seconds = 0;
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    //  Functions associated with the timer.
    
    func startTimer() {
        if isTimerRunning == false { runTimer() }
    }
    
    func pauseTimer() { timer.invalidate() }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 0
        timerImage.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
    }
    
    func updateTimer() {
        seconds += 1
        timerImage.text = timeString(time: TimeInterval(seconds))
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    ////////////////////////////////////////////////////////////////////////
    
    //  Functions to enable the picker view and set the proper variables
    
    @IBOutlet weak var dropDown: UIPickerView!
    var names = ["parkingSpot1", "parkingSpot2", "parkingSpot3", "parkingSpot4", "parkingSpot5", "parkingSpot6"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return names.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return names[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { self.EVSEForMe = self.names[row] }
    func textFieldDidBeginEditing(_ textField: UITextField) { self.dropDown.isHidden = false }
    
    ///////////////////////////////////////////////////////////////////////////
    
    //  Functions associated with the observer/managing the car charger.
    
    
    @IBAction func addToAlert(_ sender: Any) {
        
        if !isInUseFlag {
            resetTimer()
            startTimer()
        }
        
        if !isInUseFlag && (EVSEForMe != "") {
            isInUseFlag = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.addChargingAlert(self.ref, EVSE: EVSEForMe)
//            refHandle = self.ref.child("EVApp/EVAppData").child(EVSEForMe).observe(FIRDataEventType.value, with: { snap in
//                let state = String(describing: snap.childSnapshot(forPath: "EVSEState").valueInExportFormat()!)
//                if (state == "4") {
//                    //  If the car has charged then stop checking it and call the helper function.
//                    self.pauseTimer()
//                    print("Car is done charging please move it!")
//                    self.ref.child("EVApp/EVAppData").child(self.EVSEForMe).removeObserver(withHandle: self.refHandle)
//                    self.carIsCharged()
//                }
//                else {
//                    print("Car is still charging!")
//                }
//            })
        } else if EVSEForMe == "" {
            print("Please enter a valid ID")
        } else {
            onlyOneCar()
        }
    }
    
    //  This function removes the observer from the car.
    
    @IBAction func removeCar(_ sender: Any) {
        if isInUseFlag {
            self.pauseTimer()
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
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "home") as! LoginViewController
                    self.navigationController?.pushViewController(loginVC, animated: true)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logMeOut(_:)))
    }
    
}
