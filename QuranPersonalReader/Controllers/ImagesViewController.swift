//
//  ImagesViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/28/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ImagesViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var superTop: NSLayoutConstraint!
    @IBOutlet weak var safeTop: NSLayoutConstraint!
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var pageNumberLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var dailyPages = UserDefaults.standard.integer(forKey: "dailyPages")
    var dailyPagesArray:[Int] = []
    var currentViewControllerIndex = 0
    var player:AVAudioPlayer?
    var pageNumber:Int?
    var juzPageNumber:Int?
    var completedPages = UserDefaults.standard.integer(forKey: "pagesRead")
    var components:Int = 0
    var juzInitialNumber:Double = 0
    var juzNumber:Int = 0
    var combinedCurrentDate = ""
    var combinedYesterdayDate = ""
    var heightConstraintContentView: NSLayoutConstraint!
    var Url:String?
    var firstTime:Bool = false
    var pagesToRead:[Int] = []
    var currentlyFinishedAudioNumberOfPages = 0
    var currentlyFinishedNumberOfPages:Int?
    var deviceIsLandscape : Bool?
    var duration = 0.0
    var assets = [String]()
    lazy var newPlayer = AVQueuePlayer()
    var number: CGFloat?
    
    override func viewDidLoad() {
        LocalNotificationManager.shared.scheduleNotifications()
        deviceIsLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
        NotificationCenter.default.addObserver(self, selector: #selector(setSuperConstraints(_:)), name: Notification.Name(rawValue: "FullScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setSafeConstraints(_:)), name: Notification.Name(rawValue: "Non-FullScreen"), object: nil)
        
        playPauseButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 20)
        number = navigationController?.navigationBar.frame.height
        
        do {
          try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
          print("Failed to set audio session category.  Error: \(error)")
        }
    }
    
    @objc func setSuperConstraints(_ notification: Notification) {
        if traitCollection.userInterfaceStyle == .dark {
            bgView.backgroundColor = .init(red: 0.15/1, green: 0.15/1, blue: 0.15/1, alpha: 1)
        }
        iPadFixConstraints()
    }
    
    @objc func setSafeConstraints(_ notification: Notification) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            safeTop.isActive = true
            superTop.isActive = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getCurrentDate()
        lastPage()
        removeExtraPagesWhenReturningToVC()
        pageNumber = completedPages + 1
        dailyPages = UserDefaults.standard.integer(forKey: "dailyPages")
        setAudioPageArrayForiPad()
        currentlyFinishedNumberOfPages = ((UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape) ?? false) ? 2 : 1
        self.title = String(pageNumber!)
        if pageNumberLabel != nil {
            pageNumberLabel.text = String(pageNumber!)
        }
        tabBarController?.tabBar.items![0].title = "Today"
        contentView.backgroundColor = .white
        if self.traitCollection.userInterfaceStyle == .dark {
            bgView.backgroundColor = .black
        } else {
            bgView.backgroundColor = .white
        }
    }
    
    override func viewDidLayoutSubviews() {
//        iPadFixConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        produceArray()
        bottomConstraint.constant = self.tabBarController!.tabBar.frame.height/2
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageNumberLabel.removeFromSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firstTime = true
        player?.pause()
    }
    
    func queueAudioFiles(completion: @escaping () -> ()) {
            
        for page in 1...dailyPages {
            fixForPageOne()
            juzInitialNumber = (Double((juzPageNumber! - 1)) / 20).rounded(.up)
            juzNumber = Int(juzInitialNumber)
            let threeDigitNumber = String(format: "%03d", pagesToRead[page - 1])
            Url = "https://www.aswaatulqurraa.com/files/Pages/Abu%20Bakr%20al%20Shatri%20(15%20Liner)/\(juzNumber)/\(threeDigitNumber).mp3"
            let newAsset = AVAsset(url: URL(string: Url ?? "")!)
            let newAVPlayerItem = AVPlayerItem(asset: newAsset)
            newPlayer.insert(newAVPlayerItem, after: nil)
            
            let asset = AVURLAsset(url: URL(string: "\(Url ?? "")")!)
            duration += Double(CMTimeGetSeconds(asset.duration))
            if page == dailyPages {
                NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: newAVPlayerItem)
                completion()
            }
        }
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        UserDefaults.standard.set(false, forKey: "AudioPlaying")
    }
    
    func runFirstTime(completion: @escaping () -> ()) {
            queueAudioFiles() { [self] in
                newPlayer.playImmediately(atRate: 1.0)
                setupRemoteTransportControls()
                setupNowPlaying()
                UserDefaults.standard.set(true, forKey: "AudioPlaying")
                completion()
            }
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {

        if newPlayer.items().count == 0 {
            
            runFirstTime { [self] in
                if duration == 0.0 {
                    playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    newPlayer.removeAllItems()
                    let alert = UIAlertController(title: "Error", message: "The audio has failed to play, please check connection and try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    present(alert, animated: true)
                } else {
                    playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                }
            }
        } else if newPlayer.rate != 0 {
            newPlayer.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            newPlayer.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Done?", message: "Are you done reading your pages for today?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            self.doneReading()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        currentlyFinishedNumberOfPages = 0
        relaunchVC()
    }
    
    func removeExtraPagesWhenReturningToVC() {
        if firstTime == true {
            relaunchVC()
        }
    }
    
    func doneReading() {
        if pageNumber! >= 604 {
            finishedFullQuran()
        } else {
            finishedTodayReading()
        }
        
        setStreaks()
        
        LocalNotificationManager.shared.requestPushNotificationsPermissions()
        
        deleteArrayItems()
        getTodaysDate()
        UserDefaults.standard.set(components, forKey: "todaysDate")
        UserDefaults.standard.set("\(combinedCurrentDate)", forKey: "lastDate")
        UserDefaults.standard.set(true, forKey: "readToday")
        CoreDataManager().save()
    }
    
    func relaunchVC() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ImagesViewController")
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func setStreaks() {
        getCurrentDate()
        getYesterdaysDate()
        
        if UserDefaults.standard.value(forKey: "lastDate") != nil && combinedYesterdayDate == String(UserDefaults.standard.value(forKey: "lastDate")! as! String) {
            UserDefaults.standard.set(UserDefaults.standard.value(forKey: "CurrentStreak") as! Int + 1, forKey: "CurrentStreak")
        } else if UserDefaults.standard.value(forKey: "lastDate") != nil && combinedCurrentDate == String(UserDefaults.standard.value(forKey: "lastDate")! as! String) {
            
        } else {
            UserDefaults.standard.set(1, forKey: "CurrentStreak")
        }
        
        if UserDefaults.standard.value(forKey: "MaxStreak") == nil  || (UserDefaults.standard.value(forKey: "CurrentStreak") as! Int > UserDefaults.standard.value(forKey: "MaxStreak") as! Int) {
            UserDefaults.standard.set(UserDefaults.standard.value(forKey: "CurrentStreak") as! Int, forKey: "MaxStreak")
        }
        CoreDataManager().save()
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] event in
            if newPlayer.rate == 0.0 {
                newPlayer.play()
                setupNowPlaying()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if newPlayer.rate == 1.0 {
                newPlayer.pause()
                setupNowPlaying()
                return .success
            }
            return .commandFailed
        }
    }
    
    func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        
        if dailyPages > 1 {
            nowPlayingInfo[MPMediaItemPropertyTitle] = "P\(pageNumber ?? 0)-\(Int(pageNumber ?? 1) + Int(dailyPages) - 1)"
        } else {
            nowPlayingInfo[MPMediaItemPropertyTitle] = "P\(pageNumber ?? 0)"
        }

        if let image = UIImage(named: "lockscreen") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Daily Quran"
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = newPlayer.rate
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        let currentTime = CMTimeGetSeconds(newPlayer.currentTime())
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = currentTime/duration

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setAudioPageArrayForiPad() {
        for page in 0...dailyPages - 1 {
            pagesToRead.append(pageNumber! + page)
        }
    }
    
    func lastPage() {
        if UIDevice.current.userInterfaceIdiom == .pad && ((UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape)!) && (currentViewControllerIndex == 2 || currentViewControllerIndex == 1) {
            UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 1
            }
        } else if currentViewControllerIndex != 1 {
            doneButton.alpha = 0
        } else {
            doneButton.alpha = 1
        }
    }
    
    func iPadFixConstraints() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            safeTop.isActive = false
            superTop.isActive = true
            superTop.constant = 10.0
        }
    }
    
    func finishedFullQuran() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let vc = storyboard!.instantiateViewController(withIdentifier: "CompletedQuranViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        } else {
            let vc = storyboard!.instantiateViewController(identifier: "CompletedQuranViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func finishedTodayReading() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let vc = storyboard!.instantiateViewController(withIdentifier: "DoneReadingViewController")
            vc.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.first?.rootViewController = vc
        } else {
            let vc = storyboard!.instantiateViewController(identifier: "DoneReadingViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
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
    
    func fixForPageOne() {
        if pagesToRead[currentlyFinishedAudioNumberOfPages] == 1 {
            juzPageNumber = pagesToRead[currentlyFinishedAudioNumberOfPages] + 1
        } else if pagesToRead[currentlyFinishedAudioNumberOfPages] > 601 {
            juzPageNumber = pagesToRead[currentlyFinishedAudioNumberOfPages] - 4
        } else {
            juzPageNumber = pagesToRead[currentlyFinishedAudioNumberOfPages]
        }
        
    }
    
    func produceArray() {
        completedPages = UserDefaults.standard.integer(forKey: "pagesRead")
        for pages in 1...dailyPages{
            if pages + completedPages < 605 {
                self.dailyPagesArray.insert(pages + completedPages, at: 0)
            }
        }
        self.currentViewControllerIndex = self.dailyPagesArray.count
        self.configurePageViewController()
    }
    
    func getTodaysDate() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.M.YYYY"
        let calendar = Calendar.current
        components = calendar.component(.day, from: currentDate)
    }
    
    func deleteArrayItems() {
        dailyPagesArray.removeAll()
        completedPages += dailyPages
        produceArray()
        completedPages = UserDefaults.standard.integer(forKey: "pagesRead")
        UserDefaults.standard.set(completedPages + dailyPages, forKey: "pagesRead")
        CoreDataManager().save()
    }
    
    func configurePageViewController() {
        
        guard let pageViewController = storyboard?.instantiateViewController(identifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else {
            return
        }
        
        self.doneButton.alpha = 0
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view!]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else {
            return
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else {
            return .max
        }
        
        guard let nextViewController = detailViewControllerAt(index: currentViewControllerIndex - 1) else {
            pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
            return .max
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad && ((UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape)!) && dailyPagesArray.count > 1 && currentViewControllerIndex != 0  {
            pageViewController.isDoubleSided = true
            pageViewController.setViewControllers([nextViewController ,startingViewController], direction: .forward, animated: true)
            return .mid
        } else {
            pageViewController.isDoubleSided = false
            pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
            return .max
        }
    }
    
    
    func detailViewControllerAt(index: Int) -> DataViewController? {
        
        if index > dailyPagesArray.count || dailyPagesArray.count == 0 {
            return nil
        }
        
        let dataViewController: DataViewController = (storyboard?.instantiateViewController(identifier: String(describing: DataViewController.self)) as? DataViewController)!
        
        if index == 0 {
            return nil
        }
        
        dataViewController.index = index
        dataViewController.quranPage = dailyPagesArray[index - 1]
        
        return dataViewController
    }
    
}

extension ImagesViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dailyPagesArray.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let dataViewController = viewController as? DataViewController
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentlyFinishedNumberOfPages != pagesToRead.count {
            currentlyFinishedNumberOfPages! += 1
        }
        
        if (currentIndex == 1 && (deviceIsLandscape == true) && self.dailyPages % 2 == 0 && currentlyFinishedNumberOfPages == pagesToRead.count) || (!deviceIsLandscape! && currentIndex == 1)  {
            
            let alert = UIAlertController(title: "Done?", message: "Are you done reading your pages for today?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                self.doneReading()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
            return nil
        }
        
        pageNumber! += 1
        if currentIndex != 0 { currentIndex -= 1 }
        if currentViewControllerIndex == 1 { currentViewControllerIndex += 1 }
        
        if (currentIndex == 0) && (deviceIsLandscape == true) && currentlyFinishedNumberOfPages == pagesToRead.count {
            let nextViewController = detailViewControllerAt(index: currentViewControllerIndex - 1)
            let emptyViewController = EmptyViewController()
            pageViewController.setViewControllers([emptyViewController, nextViewController!], direction: .reverse, animated: true)
            UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 1
            }
        }
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let dataViewController: DataViewController = (viewController as? DataViewController)!
        
        guard var currentIndex = dataViewController.index else {
            return nil
        }
        
        if currentIndex == dailyPagesArray.count {
            return nil
        }
        
        pageNumber! -= 1
        if currentIndex == 0 && (deviceIsLandscape == true) { } else { currentIndex += 1 }
        currentlyFinishedNumberOfPages! -= 1
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 1 {
            UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 0
            }
        }
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        }
        
        if pageNumberLabel != nil {
            pageNumberLabel.text = "\(UserDefaults.standard.value(forKey: "currentPage") ?? pageNumber!)"
        }
        self.title = "\(UserDefaults.standard.value(forKey: "currentPage") ?? pageNumber!)"
        tabBarController?.tabBar.items![0].title = "Today"
        
        var index = ((pageViewController.viewControllers!.first as! DataViewController).index)!
        index = dailyPages - index
        completedPages = UserDefaults.standard.integer(forKey: "pagesRead")
        if index == dailyPages - 1 {
            UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 0
            }
        }
    }
}

