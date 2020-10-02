//
//  SettingsViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/29/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import LanguageManager_iOS

class NewSettingsViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    var previewItem: NSURL?
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var sections: [(String, [SettingsItem])] = []
    var my:UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var maxStreak = UserDefaults.standard.value(forKey: "MaxStreak")
    var currentStreak = UserDefaults.standard.value(forKey: "CurrentStreak")
    var lastSavedDate:String { UserDefaults.standard.value(forKey: "lastDate") != nil ? (UserDefaults.standard.value(forKey: "lastDate") as! String) : "nil" }
    var combinedBeforeYesterdayDate = ""
    var combinedYesterdayDate = ""
    var combinedCurrentDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections.append(("Configuration".localiz(), [.notifications, .changeDailyPages, .specialChapters]))
        sections.append(("Spread the love".localiz(), [.mission, .contact, .share]))
        sections.append(("More".localiz(), [.terms ,.restart]))
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.reloadData()
        profileTableView.tableFooterView = UIView()
        backgroundView.backgroundColor = .secondarySystemBackground
        
        navigationController?.title = "Settings".localiz()
        self.title = "Settings".localiz()
        if LanguageManager.shared.currentLanguage == .ar {
            headerLabel.font = headerLabel.font.withSize(15)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backItem?.title = "Settings".localiz()
        navigationController?.title = "Settings".localiz()
        checkForStreaks()
    }
    
    func checkForStreaks() {
        getCurrentDate()
        getYesterdaysDate()
        
        if combinedYesterdayDate != lastSavedDate && combinedCurrentDate != lastSavedDate {
            UserDefaults.standard.set(0, forKey: "CurrentStreak")
            currentStreak = 0
        }
        
        if (maxStreak == nil) || (maxStreak as! Int == 0 && currentStreak as! Int == 0) {
            headerLabel.text = "Build a habit of reading to get a streak going!".localiz()
        } else if (currentStreak == nil || currentStreak as! Int == 0) && maxStreak != nil {
            headerLabel.text = "Your Max Streak is".localiz() + " \(maxStreak!) 🔥," + " get a streak going!".localiz()
        } else if (currentStreak != nil) && ((currentStreak as! Int) < (maxStreak as! Int)) {
            headerLabel.text = "Current Streak:".localiz() + "\(currentStreak!) 🔥," + "Max Streak:".localiz() + " \(maxStreak!)." + " Try to beat it!".localiz()
        } else {
            headerLabel.text = "Current Streak:".localiz() + " \(currentStreak!) 🔥." + " This is your Max Streak, keep it up!".localiz()
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
    
    func getYesterdaysDate() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.M.YYYY"
        let calendar = Calendar.current
        let componentsDay = calendar.component(.day, from: currentDate)
        let componentsMonth = calendar.component(.month, from: currentDate)
        let componentsYear = calendar.component(.year, from: currentDate)
        combinedYesterdayDate = "\(componentsDay - 1).\(componentsMonth).\(componentsYear)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsTableViewCell
        let item = sections[indexPath.section].1[indexPath.row]
        cell.setup(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        headerView.tintColor = .secondarySystemBackground
        
        let label = UILabel(frame: CGRect(x: 25, y: 10, width: view.frame.width - 32, height: 30))
        label.text = sections[section].0
        label.textColor = .secondaryLabel
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sections[indexPath.section].1[indexPath.row] {
        case .terms:
            showPrivacyAndTerms()
        case .mission:
            tappedMission()
        case .contact:
            tappedContact()
        case .share:
            tappedShare()
        case .notifications:
            tappedNotifications()
        case .restart:
            tappedRestart()
        case .changeDailyPages:
            tappedChangeDailyPages()
        case .specialChapters:
            tappedSpecialChapters()
        }
    }
    
    func tappedSpecialChapters() {
        let  vc = storyboard?.instantiateViewController(identifier: "SpecialSoarViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func presentEditQs() {
        let vc = storyboard?.instantiateViewController(identifier: "EditQuestionsViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tappedNotifications() {
        let vc = NotificationsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tappedRestart() {
        let alert = UIAlertController(title: "Reset".localiz(), message: "Are you sure you want to reset app?".localiz(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset".localiz(), style: .destructive, handler: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FirstLaunchViewController")
            UserDefaults.standard.set(1, forKey: "dailyPages")
            UserDefaults.standard.set(0, forKey: "todaysDate")
            UIApplication.shared.windows.first?.rootViewController =  vc
        }))
        present(alert, animated: true)
    }
    
    func configurationTextField(textField: UITextField!) {
        
        if textField != nil {
            self.my = textField!
            self.my.text = String(UserDefaults.standard.integer(forKey: "dailyPages"))
            self.my.keyboardType = .numberPad
        }
    }
    
    
    func tappedChangeDailyPages() {
        let alert = UIAlertController(title: "Change Daily Pages".localiz(), message: "How many pages would you like to read daily?".localiz(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm".localiz(), style: .default, handler:{ (UIAlertAction)in
            let number = Int(self.my.text!)
            if number != 0 {
                UserDefaults.standard.set(Int(self.my.text!), forKey: "dailyPages")
            } else {}
        }))
        alert.addTextField(configurationHandler: configurationTextField(textField: ))
        present(alert, animated:true)
    }
    
    func showPrivacyAndTerms() {
        openUrl(urlString: "https://getterms.io/g/?product_name=DailyQuran&name=DailyQuran&location=UK&effective_date=30+May+2020&language=en-us")
    }
    
    func tappedMission() {
        let vc = AboutViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tappedShare() {
        
        guard let url = URL(string: "https://apps.apple.com/gb/app/daily-quran-bulid-a-habit/id1516253962") else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: profileTableView.cellForRow(at: IndexPath(row: 1, section: 1))!.frame.midX, y: (profileTableView.cellForRow(at: IndexPath(row: 2, section: 1))!.frame.maxY) + (80) + (40), width: 0, height: 0)
            activityViewController.popoverPresentationController?.permittedArrowDirections = [.up]
        }
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func tappedContact() {
        let alert = UIAlertController(title: "Contact Me".localiz(), message: "I love hearing from you! If you give me a shout on any of the platforms below I'll be quick to answer.".localiz(), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Twitter".localiz(), style: .default, handler: { (action) in
            self.openTwitter()
        }))
        alert.addAction(UIAlertAction(title: "iMessage".localiz(), style: .default, handler: { (action) in
            self.sendMessage()
        }))
        alert.addAction(UIAlertAction(title: "Email".localiz(), style: .default, handler: { (action) in
            self.sendEmail()
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: profileTableView.cellForRow(at: IndexPath(row: 1, section: 1))!.frame.midX, y: (profileTableView.cellForRow(at: IndexPath(row: 1, section: 1))!.frame.maxY) + (80) + (40), width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = [.up]
        }
        self.present(alert, animated: true)
    }
    
    func openTwitter() {
        var url = ""
        let appURL = "twitter:///user?screen_name=mousaalwaraki"
        let webURL = "https://twitter.com/mousaalwaraki"
        let application = UIApplication.shared
        if application.canOpenURL(URL(string: appURL)!) {
            url = appURL
        } else {
            url = webURL
        }
        openUrl(urlString: url)
    }
    
    func sendMessage() {
        if MFMessageComposeViewController.canSendText() {
            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.recipients = ["mousa.alwaraki@gmail.com"]
            present(messageComposeViewController, animated: true, completion: nil)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["mousa.alwaraki@gmail.com"])
            mail.setSubject("Daily Quran")
            present(mail, animated: true)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

protocol SettingsItemDelegate {
    func tappedMission()
    func showPrivacyAndTerms()
}

enum SettingsItem: CaseIterable {
    case terms
    case mission
    case contact
    case share
    case notifications
    case restart
    case changeDailyPages
    case specialChapters
}

extension SettingsItem {
    
    var title: String {
        switch self {
        case .notifications:
            return "Notifications".localiz()
        case .terms:
            return "Your Privacy".localiz()
        case .mission:
            return "Our Mission".localiz()
        case .contact:
            return "Get in Touch".localiz()
        case .share:
            return "Share Daily Quran".localiz()
        case .restart:
            return "Reset App".localiz()
        case .changeDailyPages:
            return "Change Daily Pages".localiz()
        case .specialChapters:
            return "Special Chapters".localiz()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .terms:
            return UIImage(systemName: "hand.raised.slash.fill")
        case .mission:
            return UIImage(systemName: "heart.fill")
        case .contact:
            return UIImage(systemName: "envelope.fill")
        case .share:
            return UIImage(systemName: "square.and.arrow.up.fill")
        case .notifications:
            return UIImage(systemName: "rosette")
        case .restart:
            return UIImage(systemName: "repeat")
        case .changeDailyPages:
            return UIImage(systemName: "2.circle.fill")
        case .specialChapters:
            return UIImage(systemName: "bookmark.fill")
        }
    }
    
    var color: UIColor {
        switch self {
        case .terms:
            return .systemOrange
        case .mission:
            return .systemRed
        case .contact:
            return .systemPurple
        case .share:
            return .systemGreen
        case .notifications:
            return .systemRed
        case .restart:
            return .systemRed
        case .changeDailyPages:
            return .systemBlue
        case .specialChapters:
            return .systemYellow
        }
    }
}

