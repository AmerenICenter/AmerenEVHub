//
//  AppDelegate.swift
//  Ameren EV Hub
//
//  Created by Rick Lewis on 5/24/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Configure firebase on launch of application.
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func addChargingAlert(_ ref: FIRDatabaseReference, EVSE EVSEForMe: String) {
        ref.child("EVApp/EVAppData").child(EVSEForMe).observe(FIRDataEventType.value, with: { snap in
            let state = String(describing: snap.childSnapshot(forPath: "EVSEState").valueInExportFormat()!)
            if (state == "4") {
                //  If the car has charged then stop checking it and call the helper function.
                print("Car is done charging please move it!")
                ref.child("EVApp/EVAppData").child(EVSEForMe).removeAllObservers()
            }
            else {
                print("Car is still charging!")
            }
        })
    }
}

