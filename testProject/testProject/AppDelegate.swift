//
//  AppDelegate.swift
//  testProject
//
//  Created by miniMAC Sferea on 02/09/21.
//

import UIKit
import AVFoundation
//import Pushwoosh

//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let audioSession = AVAudioSession.sharedInstance()
                
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch  {
            print("Audio session failed")
        }
        
        //initialization code
        //set custom delegate for push handling, in our case AppDelegate
//        Pushwoosh.sharedInstance()?.delegate = self;
                
        //register for push notifications!
//        Pushwoosh.sharedInstance()?.registerForPushNotifications()

        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //handle token received from APNS
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Pushwoosh.sharedInstance()?.handlePushRegistration(deviceToken)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device token: \(deviceTokenString)")
        print(deviceToken)
    }
    
    //handle token receiving error
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        Pushwoosh.sharedInstance()?.handlePushRegistrationFailure(error);
    }
    
    //this is for iOS < 10 and for silent push notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        Pushwoosh.sharedInstance()?.handlePushReceived(userInfo)
        completionHandler(.noData)
    }
    
    //this event is fired when the push gets received
//    func pushwoosh(_ pushwoosh: Pushwoosh!, onMessageReceived message: PWMessage!) {
//        print("onMessageReceived: ", message.payload.description)
//    }
    
    //this event is fired when user taps the notification
//    func pushwoosh(_ pushwoosh: Pushwoosh!, onMessageOpened message: PWMessage!) {
//        print("onMessageOpened: ", message.payload.description)
//    }
    
    //Orientation Variables
    var myOrientation: UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }
    
}

