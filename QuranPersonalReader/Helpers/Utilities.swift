//
//  Utilities.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/29/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController {
func openUrl(urlString: String) {
    if let url = URL(string: urlString) {
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true)
    }
}
}

class Utilities {
    static var userHour: Int {
        var userHour = 20
        
        if UserDefaults.standard.value(forKey: "userHour") != nil {
            userHour = UserDefaults.standard.integer(forKey: "userHour")
        }
        
        return userHour
    }
    
    static var userMinute: Int {
        var userMinute = 0
        
        if UserDefaults.standard.value(forKey: "userMinute") != nil {
            userMinute = UserDefaults.standard.integer(forKey: "userMinute")
        }
        
        return userMinute
    }
    
//    func getCurrentDate() {
//        let currentDate = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.M.YYYY"
//        let calendar = Calendar.current
//        let componentsDay = calendar.component(.day, from: currentDate)
//        let componentsMonth = calendar.component(.month, from: currentDate)
//        let componentsYear = calendar.component(.year, from: currentDate)
//        var combinedCurrentDate = ""
//        var combinedCurrentDate = "\(componentsDay).\(componentsMonth).\(componentsYear)"
//    }
    
}
