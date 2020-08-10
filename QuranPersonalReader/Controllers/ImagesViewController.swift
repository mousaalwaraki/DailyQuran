//
//  ImagesViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/28/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit
import AVFoundation

class ImagesViewController: UIViewController, AVAudioPlayerDelegate, DataViewControllerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var superTop: NSLayoutConstraint!
    @IBOutlet weak var safeTop: NSLayoutConstraint!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        getCurrentDate()
        lastPage()
        removeExtraPagesWhenReturningToVC()
        pageNumber = completedPages + 1
        dailyPages = UserDefaults.standard.integer(forKey: "dailyPages")
        setAudioPageArrayForiPad()
        currentlyFinishedNumberOfPages = ((UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape) ?? false) ? 2 : 1
        }
    
    override func viewWillAppear(_ animated: Bool) {
        produceArray()
        iPadFixConstraints()
        setBGColor(to: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firstTime = true
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {
        
        getJuzNumber()
        
        if player == nil {
            playPauseButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 20)
            playPauseButton.setImage(UIImage(systemName: "slowmo"), for: .normal)
        }
        
        guard let audioPlayer = player else {
            
            URLSession.shared.dataTask(with: URL(string: "\(Url ?? "smth")")!) { (data, response, error) in
                //DONE DOWNLOADING
                guard let data = data, error == nil else {
//                    print("Something went wrong")
                    self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    return
                }
                self.player = try! AVAudioPlayer(data: data, fileTypeHint: AVFileType.mp3.rawValue)
                self.player?.prepareToPlay()
//                self.player?.enableRate = true
//                self.player?.rate = 50
                self.player?.play()
                self.player!.delegate = self
                DispatchQueue.main.sync {
                    self.playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                }
            }.resume()
            return
        }
        
        if audioPlayer.isPlaying {
            pauseAudio()
        } else {
            playAudio()
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        if pageNumber == 604 {
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
        UserDefaults.standard.set("true", forKey: "readToday")
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
    }
    
    func pauseAudio() {
        self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        player?.pause()
    }
    
    func playAudio() {
        self.playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        player?.play()
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
            safeTop.isActive = true
            superTop.isActive = false
            view.backgroundColor = .white
        }
    }
    
    func setBGColor(to color: UIColor) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            view.backgroundColor = color
        }
    }
    
    func finishedFullQuran() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let vc = storyboard!.instantiateViewController(withIdentifier: "CompletedQuranViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "CompletedQuranViewController")
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true)
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
    
    func getJuzNumber() {
        fixForPageOne()
        juzInitialNumber = (Double((juzPageNumber! - 1)) / 20).rounded(.up)
        juzNumber = Int(juzInitialNumber)
        let threeDigitNumber = String(format: "%03d", pagesToRead[currentlyFinishedAudioNumberOfPages])
        Url = "https://www.aswaatulqurraa.com/files/Pages/Abu%20Bakr%20al%20Shatri%20(15%20Liner)/\(juzNumber)/\(threeDigitNumber).mp3"
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
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        self.player = nil

        if currentlyFinishedAudioNumberOfPages < pagesToRead.count - 1 {
            currentlyFinishedAudioNumberOfPages += 1
            playPauseTapped(self)
        } else {
            self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.player = nil
        }
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
        dataViewController.delegate = self
        
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
        
        let deviceIsLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
        
        if currentlyFinishedNumberOfPages != pagesToRead.count {
            currentlyFinishedNumberOfPages! += 1
        }
        
        if currentIndex == 1 && deviceIsLandscape && self.dailyPages % 2 == 0 && currentlyFinishedNumberOfPages == pagesToRead.count  {
            
            let alert = UIAlertController(title: "Done?", message: "Are you done reading your pages for today?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                self.doneTapped(self)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
            return nil
        }
        
        pageNumber! += 1
        currentIndex -= 1
        
        if currentIndex == 1 && deviceIsLandscape && currentlyFinishedNumberOfPages == pagesToRead.count {
//            self.dailyPages % 2 != 0
            let nextViewController = detailViewControllerAt(index: currentViewControllerIndex - 1)
            let emptyViewController = EmptyViewController()
            pageViewController.setViewControllers([emptyViewController, nextViewController!], direction: .reverse, animated: true)
            UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 1
            }
            self.currentlyFinishedNumberOfPages! -= 1
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
        currentIndex += 1
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

