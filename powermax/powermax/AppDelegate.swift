//
//  AppDelegate.swift
//  powermax
//
//  Created by newpower on 2019/11/27.
//  Copyright © 2019 newpower. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //应用程序启动后自定义的重写点。
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        //在创建新的场景会话时调用。
        //使用此方法选择要使用创建新场景的配置。
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        //当用户放弃场景会话时调用。
        //如果在应用程序未运行时丢弃了任何会话，则将在application:didffinishlaunchingwithoptions之后不久调用该会话。
        //使用此方法可以释放特定于丢弃场景的任何资源，因为它们不会返回。
    }


}

