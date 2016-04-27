//
//  AppDelegate.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/7/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit
import Parse
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Patient.registerSubclass()
        Department.registerSubclass()
        InsuranceInfo.registerSubclass()
        Address.registerSubclass()
        Institution.registerSubclass()
        FinancialInformation.registerSubclass()
        PatientRecord.registerSubclass()
        Treatment.registerSubclass()
        Prescription.registerSubclass()
        MIMSUser.registerSubclass()
        Appointment.registerSubclass()

        //Surgery.registerSubclass()
        //Immunization.registerSubclass()

        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barStyle = UIBarStyle.BlackOpaque
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "com.mims.umllovers.appID199384755"
            $0.clientKey = "com.mims.umllovers.pbush25.masterKey39048039"
            $0.server = "http://mims-umllovers.herokuapp.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateInitialViewController()
        let dashbaordVC = storyboard.instantiateViewControllerWithIdentifier("MainEntryPointForHome")
        
        //Set the root view as the main view if the user is already logged in
        if MIMSUser.currentUser() != nil && MIMSUser.currentUser()!.authenticated {
            self.window?.rootViewController = dashbaordVC
        } else {
            //otherwise just present the loginVC
            self.window?.rootViewController = loginVC
        }

        
        IQKeyboardManager.sharedManager().enable = true
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

