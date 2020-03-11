//
//  AppDelegate.swift
//  Salesken
//
//  Created by istar on 18/02/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let callManager = CallManager()
    var providerDelegate: ProviderDelegate!

    class var shared: AppDelegate {
      return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        providerDelegate = ProviderDelegate(callManager: callManager)
        // Override point for customization after application launch.
        return true
    }
    func displayIncomingCall(uuid: UUID,handle: String,hasVideo: Bool,completion: ((Error?) -> Void)?) {
      providerDelegate.reportIncomingCall(uuid: uuid,handle: handle,hasVideo: hasVideo,completion: completion)
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("default config for connecting scene session")
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("scene discarded")
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

