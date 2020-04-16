//
//  SceneDelegate.swift
//  powermax
//
//  Created by newpower on 2019/11/27.
//  Copyright © 2019 newpower. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        //当系统正在释放场景时调用。 关闭程序时调用
        //这发生在场景进入背景后不久，或当其会话被丢弃时。
        //释放与此场景关联的任何资源，这些资源可以在下次场景连接时重新创建。
        //场景稍后可能会重新连接，因为其会话不必被丢弃（请参见“application:didDiscardSceneSessions”）。
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        //当场景从非活动状态移动到活动状态时调用。
        //使用此方法可以重新启动场景处于非活动状态时暂停（或尚未启动）的任何任务。
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        //当场景从活动状态移动到非活动状态时调用。
        //这可能是由于临时中断（例如来电）造成的。
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        //称为场景从背景过渡到前景。 进入前台时调用
        //使用此方法撤消在输入背景时所做的更改。
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        //称为场景从前景过渡到背景。 进入后台时调用
        //使用此方法保存数据、释放共享资源并存储足够的特定于场景的状态信息
        //将场景还原回其当前状态。
    }


}

