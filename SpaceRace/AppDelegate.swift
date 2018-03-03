    //
//  AppDelegate.swift
//  SpaceRace
//
//  Created by Dalton Ng on 13/2/18. 
//  Copyright © 2018 AppsLab. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Setup our custom navigation bar
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
        UINavigationBar.appearance().isTranslucent = true
        
        //let navigationBarAppearance = UINavigationBar.appearance()
        
        UINavigationBar.appearance().tintColor = uicolorFromHex(rgbValue: 0xffffff)
        //navigationBarAppearance.barTintColor = uicolorFromHex(rgbValue: 0x28384D)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        //navigationBarAppearance.isTranslucent = true
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    
        /*        self.navigationController?.navigationBar.isTranslucent = true
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
         var bounds = self.navigationController?.navigationBar.bounds
         bounds?.size.height += 20
         bounds?.origin.y -= 20
         visualEffectView.isUserInteractionEnabled = false
         visualEffectView.frame = bounds!
         visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         self.navigationController?.navigationBar.addSubview(visualEffectView)
         visualEffectView.layer.zPosition = -1
         print("Blurring...")
     */
        //UINavigationBar.appearance().barTintColor = UIColor(patternImage: #imageLiteral(resourceName: "bar") )
        //UINavigationBar.appearance().tintColor = .white
        //UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //UINavigationBar.appearance().isTranslucent = true
        
       // UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
      //  UINavigationBar.appearance().shadowImage = UIImage()
        
       // UINavigationBar.appearance().backgroundColor = UIColor.clear
        
       // UINavigationBar.appearance().isTranslucent = true
        
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
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}

