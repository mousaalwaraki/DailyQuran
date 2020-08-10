//
//  LocalNotificationManager.swift
//  Snappy Wins
//
//  Created by Marwan Elwaraki on 30/03/2020.
//  Copyright © 2020 marwan. All rights reserved.
//

import UIKit

class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = LocalNotificationManager()
    var trigger:UNCalendarNotificationTrigger?
    var combinedCurrentDate = ""
    
    func requestPushNotificationsPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if granted {
                    self.scheduleNotifications()
                }
            }
        }
    }
    
    func scheduleNotifications() {
        //remove existing notifications
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for day in 0...4 {
        schedule(localNotifcation: getRandomNotification(), days: TimeInterval(day))
        }
    }

    func getCurrentDate() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.M.YYYY"
        let calendar = Calendar.current
        let componentsDay = calendar.component(.day, from: currentDate)
        let componentsMonth = calendar.component(.month, from: currentDate)
        let componentsYear = calendar.component(.year, from: currentDate)
        combinedCurrentDate = "\(componentsDay).\(componentsMonth).\(componentsYear)"
    }
    
    func schedule(localNotifcation: LocalNotification?, days: TimeInterval) {
        
        guard let notification = localNotifcation else {
            return
        }

        let content = UNMutableNotificationContent()
        if let title = notification.title {
            content.title = title
        }
        if let body = notification.body {
            content.body = body
        }
        
        let day = Date().addingTimeInterval(days * 86400)
        let modifiedDay = Calendar.current.date(bySettingHour: Utilities.userHour, minute: Utilities.userMinute, second: 0, of: day)
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: modifiedDay!)
        getCurrentDate()
//        if combinedCurrentDate == combinedCurrentDate {
        if "\(UserDefaults.standard.value(forKey: "readToday") ?? 1)" == "true" {
            
        } else {
            
            self.trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
        
        
        // Create the request object.
        let notificationId = "\(days)InactiveNotif"
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: self.trigger)
    
        // Schedule the request.
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        }
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

}
