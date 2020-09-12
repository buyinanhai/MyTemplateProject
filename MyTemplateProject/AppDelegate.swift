//
//  AppDelegate.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/10.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import CoreData



//: [Previous](@previous)


//: # headingOne1

/*:

* item1

* item2

* item3

*/

//: [Next](@next)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
       
        self.configMainVC()
        
        
        return true
    }

    
    private func configMainVC () {
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
            let navVC = DYBaseNavigationVC.init(rootViewController: vc);
            
            tabVC.addChild(navVC);
            
        }
        self.window?.rootViewController = tabVC;
        self.window?.makeKeyAndVisible();
        
        DYNetworkConfig.share()?.extraData = ["token": "SRn55wqmX06TlYIStQdT7WMZhTAZDdHLzNZ4eYtHGyVJuL4Hi5lVjFcEGZq%2F5erQkKAJFTDWONDU%0D%0AsaQL2JTmuw%3D%3D","userId":2984573];
        
//        DYNetworkConfig.share()?.networkBaseURL = "http://192.168.11.195:8082";
        DYNetworkConfig.share()?.networkBaseURL = "http://test.sdk.live.cunwedu.com.cn";

    }
    
    // MARK: UISceneSession Lifecycle

   
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyTemplateProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait;
    }
}

