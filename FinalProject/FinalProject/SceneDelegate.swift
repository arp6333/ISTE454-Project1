//
//  SceneDelegate.swift
//  FinalProject
//
//  Created by Ellie on 4/25/20.
//  Copyright © 2020 Ellie. All rights reserved.
//

import UIKit
import KDCalendar

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var events: [CalendarEvent] = []
    var plistPath: String = ""

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentsPathURL.appendingPathComponent("data.plist")
            if !FileManager.default.fileExists(atPath: path.path) {
                print("Attempting to copy file...")
                let localPath = Bundle.main.path(forResource: "data", ofType: "plist")!
                do {
                    try FileManager.default.copyItem(at: URL(fileURLWithPath: localPath), to: path)
                } catch (let error) {
                    print("Cannot copy item at \(localPath) to \(path): \(error)")
                }
            }
            plistPath = path.path
            print("Events read in from " + plistPath)
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: plistPath))
                let tempDict = try PropertyListSerialization.propertyList(from: data, format: nil) as! [[String: Any]]
                
                for dict in tempDict {
                    let title = dict["title"]! as! String
                    let time = dict["date"]! as! Date
                    
                    let event = CalendarEvent(title: title, startDate: time, endDate: time)
                    events.append(event)
                }
                
                // Check to see if the events were created correctly
                for event in events {
                    print("Event: \(event)")
                }
            }
            catch {
                print (error)
            }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

