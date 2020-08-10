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
//    bodyArray.append("“Journal writing gives us insights into who we are, who we were, and who we can become.“ - Sandra Marinella")
    
    newBody = bodyArray.randomElement()!
}

extension LocalNotificationManager {
    func getRandomNotification() -> LocalNotification? {
        getTitle()
        getBody()
      return LocalNotification(title: "\(newTitle)", body: "\(newBody)")
//        potentialNotifications.append(LocalNotification(title: "Reflect on your day", body: "Reflect through your day and take note of what happened."))
//        potentialNotifications.append(LocalNotification(title: "Find a win", body: "Or browse through your existing wins and celebrate them!"))
//        potentialNotifications.append(LocalNotification(title: "Just checking in", body: "It's been a while. I hope you're having a good day."))
//        potentialNotifications.append(LocalNotification(title: "Today is special", body: "It may seem like just another day. But there's a unique win in there somewhere. Find it."))
//        potentialNotifications.append(LocalNotification(title: "Add a win", body: "If you can't think of any then just read through your previous ones. And there you have it, you reflected today. Now that's a win."))
//        potentialNotifications.append(LocalNotification(title: "Smile", body: "Today is beautiful. We just need to find the beauty."))
//        potentialNotifications.append(LocalNotification(title: "Fun fact", body: "In Switzerland, it's illegal to own just one guinea pig. Want another fun fact? Learning new facts is a win. Note it down!"))
//        potentialNotifications.append(LocalNotification(title: "Fun fact", body: "Movie trailers were originally shown after the movie, hence the name 'trailers'."))
//        potentialNotifications.append(LocalNotification(title: nil, body: "Having a good day starts with you. Let's make today great."))
//        potentialNotifications.append(LocalNotification(title: "How's your day?", body: "What defines a good day for you? What moments do you consider wins? Take note of them."))
//        potentialNotifications.append(LocalNotification(title: "What's your smallest win today?", body: "Start there and work your way up. Take note of every win."))
//        potentialNotifications.append(LocalNotification(title: "Increasing your wins", body: "The quickest way to increase your wins is to pay more attention to them. What was your first win today?"))
//        potentialNotifications.append(LocalNotification(title: "Double points day!", body: "Did you know that taking note of a win makes you happier? So by saving a win, you're creating a second new win. Double win!"))
//        return potentialNotifications.randomElement()
        //potentialNotifications.append(LocalNotification(title: <#T##String?#>, body: <#T##String?#>))
    }
}
