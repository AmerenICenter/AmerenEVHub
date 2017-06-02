//
//  ScrollViewController.swift
//  Ameren EV Hub
//
//  Created by AmereniCenter4 on 6/2/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var textFields: UITextField!
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
        self.textFields.text = self.names[row]
        self.dropDown.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dropDown.isHidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
