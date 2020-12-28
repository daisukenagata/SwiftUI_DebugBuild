//
//  AppDelegate.swift
//  SwiftUI_DebugBuild
//
//  Created by 永田大祐 on 2020/12/28.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    @State var returnRes = [""]
    @ObservedObject static var c = CheckBuild()

    private func read() {

        if let urls = Bundle.main.path(forResource: "uuid", ofType:"plist" ) {
            let plist = NSDictionary(contentsOfFile: urls) as? Dictionary<String, String>
            AppDelegate.c.res(treturnRes: returnRes, uuid: plist?["uuid"] ?? "")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        read()
        // Override point for customization after application launch.
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

