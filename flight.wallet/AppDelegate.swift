//
//  AppDelegate.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 27/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let wallet = Wallet.instance
    var deviceToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.

        let notificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(pushNotificationSettings)
        
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
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("did register with settings")
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE TOKEN = \(deviceToken.toHexString())")
        
        self.deviceToken = deviceToken.toHexString()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("local", notification)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("remote", userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("remote with handler")
        
//        let notification = UILocalNotification.init()
//        notification.soundName = "default"
//        notification.alertBody = "Hey"
//
        if let data = userInfo["data"] as? [String: Any] {
            debug("utxo", data)
            
            let utxo = UTXO(dict: data)
            let walletUpdate = BitcoinWalletUpdate(utxo: utxo)
            
            wallet.update(update: walletUpdate)
        } else {
            debug("cant parse", userInfo["data"])
        }
        
        completionHandler(UIBackgroundFetchResult.noData)
    }
}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("url", url)
        
        debug("chain", url.queryParameters?["chain"] )
        debug("data", url.queryParameters?["data"])
        
        if !wallet.isLoaded {
            wallet.initCrypto()
            wallet.loaded {
                
            }
        }
        
        switch url.scheme {
        case "bitcoin":
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "TransactionReceiptViewController") as! TransactionReceiptViewController
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let navController = UINavigationController.init(rootViewController: mainViewController)
            
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                
                print("root", rootViewController)
                print("current", currentController)
                print("nav", navController)
                
                currentController.present(navController, animated: true, completion: nil)
                
                
                if let wallet = self.wallet.wallets[.Bitcoin] as? BitcoinWallet {
                    viewController.parsedTx = url.absoluteString
                    viewController.chain = .Bitcoin
                    viewController.address = wallet.addresses[0]
                    viewController.wallet = Wallet.instance
                }
                
                
                navController.pushViewController(viewController, animated: true)
            }
            
            
         
            
        case "flightwallet":
            if let chain = url.queryParameters?["chain"] {
                guard let data = url.queryParameters?["data"] else {
                    print("no data given")
                    return false
                }
                
                if chain == "bitcoin" {
                    debug("utxo json", data)
                    
                    if let walletUpdate = BitcoinWalletUpdate(from: data) {
                        wallet.update(update: walletUpdate)
                    } else {
                        print("probably bad json, cant update", data)
                    }
                }
                
            }
            
        default:
            print("dont know this scheme")
            return false
        }
        
        return true
    }
}


extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
