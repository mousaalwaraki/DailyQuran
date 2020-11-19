//
//  AppDelegate.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/28/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit
import CoreData
import LanguageManager_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LocalNotificationManager.shared.scheduleNotifications()
        LanguageManager.shared.defaultLanguage = .deviceLanguage
        if LanguageManager.shared.defaultLanguage == .ar || LanguageManager.shared.defaultLanguage == .en {} else {
            LanguageManager.shared.defaultLanguage = .en
        }
        CoreDataManager().load { (returnedData: [NSManagedObject]) in
            if returnedData.count > 0 {
                UserDefaults.standard.setValue(returnedData[0].value(forKey: "currentStreak"), forKey: "CurrentStreak")
                UserDefaults.standard.setValue(returnedData[0].value(forKey: "maxStreak"), forKey: "MaxStreak")
                UserDefaults.standard.setValue(returnedData[0].value(forKey: "lastDate"), forKey: "lastDate")
                UserDefaults.standard.setValue(returnedData[0].value(forKey: "todaysDate"), forKey: "todaysDate")
                UserDefaults.standard.setValue(returnedData[0].value(forKey: "dailyPages"), forKey: "dailyPages")
                UserDefaults.standard.setValue(returnedData[0].value(forKey: "pagesRead"), forKey: "pagesRead")
                UserDefaults.standard.setValue(returnedData[0].value(forKey: "currentPage"), forKey: "currentPage")
                UserDefaults.standard.setValue(returnedData[0].value(forKey: "readToday"), forKey: "readToday")
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        var smth:UIInterfaceOrientationMask = .portrait
        if UIDevice.current.userInterfaceIdiom == .pad {
            smth = UIInterfaceOrientationMask.portrait
        }
        return smth
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "QuranPersonalReader")
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

    static var persistentContainer: NSPersistentContainer {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    static var viewContext: NSManagedObjectContext {
        let viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        return viewContext
    }
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

}

