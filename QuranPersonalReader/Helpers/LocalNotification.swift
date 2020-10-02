//
//  LocalNotification.swift
//  Snappy Wins
//
//  Created by Marwan Elwaraki on 30/03/2020.
//  Copyright © 2020 marwan. All rights reserved.
//

import Foundation

struct LocalNotification {
    var title: String?
    var body: String?
}

var titleArray: [String] = []
var bodyArray: [String] = []
var newTitle: String = "Smth"
var newBody: String = "Smth"

func getTitle() {
    titleArray.append("Get Reading!")
    titleArray.append("Don't forget to read today!")
    titleArray.append("Read some Quran today!")
    
    newTitle = titleArray.randomElement()!
}

func getBody() {
    bodyArray.append("“Whoever reads a letter from the Book of Allah, he will have a reward. And that reward will be multiplied by ten...“ - Prophet Muhammed PBUH")
    bodyArray.append("“The best of you are the ones who learn the Qur’an and teach it to others“ - Prophet Muhammed PBUH")
    bodyArray.append("“And We send down of the Quran that which is a healing and a mercy to those who believe...“ - Qur'an [17:82]")
    bodyArray.append("“The example of a believer who recites the Qur’an is that of a citron (a citrus fruit) which is good in taste and good in smell...“ - Prophet Muhammed PBUH")
    bodyArray.append("“...And the Qur’an is a proof for you or against you.“ - Prophet Muhammed PBUH")
    bodyArray.append("“Read the Qur’an, for verily it will come on the Day of Standing as an intercessor for its companions.“ - Prophet Muhammed PBUH")
    bodyArray.append("“Verily Allah raises some people by this Book and lowers others by it.“ - Prophet Muhammed PBUH")
    bodyArray.append("“It will be said to the companion of the Qur’an: Read and elevate (through the levels of the Paradise)...“ - Prophet Muhammed PBUH")
    
    newBody = bodyArray.randomElement()!
}

extension LocalNotificationManager {
    func getRandomNotification() -> LocalNotification? {
        getTitle()
        getBody()
      return LocalNotification(title: "\(newTitle)", body: "\(newBody)")
    }
}
