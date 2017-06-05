//
//  TimerViewController.swift
//  Ameren EV Hub
//
//  Created by AmereniCenter4 on 6/5/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timerImage: UILabel!
    
    var seconds = 0;
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    
    @IBAction func startTimer(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
        }
    }
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            isTimerRunning = false
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
        }
    }
    
    @IBAction func resetTimer(_ sender: UIButton) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
}
