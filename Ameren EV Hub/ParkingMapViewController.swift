//
//  ParkingMapViewController.swift
//  Ameren EV Hub
//
//  Created by Rick Lewis on 5/24/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

// MARK: - Constants


class ParkingMapViewController: UIViewController {

    // MARK: - Class Variables
    
    // Firebase database reference
    var parkingDatabaseRef: DatabaseReference!
    
    // Parking lot space index JSON object
    var lotSpaces = [String : Any]()
    
    // MARK: - Overridden Parent Functions
    
    // ----------------------------------------------------------------
    // viewDidLoad - called whenever this controller's view is placed
    //               on the screen, loads parking lot data JSON file
    //               and queries EVSE database for charging state
    // ----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let parkingLotJSONPath = Bundle.main.path(forResource: PARKING_LOT_JSON_FILENAME, ofType: "json")
            let parkingLotJSONText = try String(contentsOfFile: parkingLotJSONPath!)
            lotSpaces = try JSONSerialization.jsonObject(with: parkingLotJSONText.data(using: String.Encoding.unicode)!, options:[]) as! [String : Any]
        } catch {
            print (error)
        }
        
        parkingDatabaseRef = Database.database().reference()
        parkingDatabaseRef.child("EVApp/EVAppData").observe(DataEventType.childAdded, with: recieveFirebaseData)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Class Functions
    
    // ----------------------------------------------------------------
    // recieveFirebaseData - callback function for Firebase dummy ESVE
    //                       data. Removes itself as a callback after
    //                       one iteration
    // ----------------------------------------------------------------

    func recieveFirebaseData(_ data: DataSnapshot) -> Void {
        print (data.valueInExportFormat() ?? "not...found")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
