//
//  CheckInViewController.swift
//  Ameren EV Hub
//
//  Created by Rick Lewis on 6/8/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import Firebase

class CheckInViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Instance Variables
    
    // Reference to parking state database
    var databaseRef: FIRDatabaseReference!
    
    // Reference to user cloud storage
    var storageRef: FIRStorageReference!
    
    // MARK: - Overridden Parent Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = FIRDatabase.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
