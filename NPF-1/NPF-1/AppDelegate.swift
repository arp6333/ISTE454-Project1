//
//  AppDelegate.swift
//  NPF-1
//
//  Created by Ellie on 1/30/20.
//  Copyright © 2020 Ellie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        let p1 : Park = Park()
        print("\(p1)")
        
        let p2 : Park = Park(parkName: "Acadia National Park", parkLocation: "Maine", dateFormed: "1919-02-26", area: "47,389.67 acres (191.8 square km)", link: "TBD", location: nil, imageLink: "TBD", parkDescription: "TBD")
        print("\(p2)")
        
        p2.set(link: "http://en.wikipedia.org/wiki/Acadia_National_Park")
        print("\(p2)")
        
        let p3 = Park(parkName: "ab", parkLocation: "na", dateFormed: "1919-02-26", area: "47,389.67 acres (191.8 square km)", link: "TBD", location: nil, imageLink: "TBD", parkDescription: "TBD")
        print("\(p3)")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

