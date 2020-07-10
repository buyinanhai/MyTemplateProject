//
//  SceneDelegate.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/10.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        let tabVC = UITabBarController.init();
        tabVC.tabBar.tintColor = UIColor.orange;
        let classArray:[[String:String]] = [
            ["class":"HomeVC","title":"首页", "icon": "tab-home"],
            ["class":"MyVC","title":"我的", "icon": "tab-my"]];
        
        for item in classArray {
            //获取命名空间也就是项目名称
            let prjName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
            let clsStr = prjName! + "."  + item["class"]!;
            
            let cls = NSClassFromString(clsStr) as! UIViewController.Type;
            
            let vc = cls.init();
            vc.tabBarItem.title = item["title"]!
            vc.tabBarItem.image = UIImage.init(named: item["icon"]!);
            let navVC = UINavigationController.init(rootViewController: vc);
            
            tabVC.addChild(navVC);
            
        }
        self.window?.rootViewController = tabVC;
        self.window?.makeKeyAndVisible();
    
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

