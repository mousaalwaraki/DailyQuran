//
//  SoorahViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 6/2/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit
import AVFoundation
import LanguageManager_iOS

class SoorahViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var safeTop: NSLayoutConstraint!
    @IBOutlet weak var superTop: NSLayoutConstraint!
    
    var currentViewControllerIndex = 0
    var numberOfPages = specialSooraChoice?.numberOfPages
    var startPage = specialSooraChoice?.pageNumber
    var juzNumber:Int = 88
    var juzInitialNumber:Double = 88
    var dailyPagesArray:[Int] = []
    var player:AVAudioPlayer?
    var playPauseButton: UIButton = UIButton(type: .system)
    var myURL = ""
    var juzPageNumber = 0
    
    override func viewDidLoad() {
        produceArray()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .done, target: self, action: #selector(playPauseTapped))
        numberOfPages = specialSooraChoice?.numberOfPages
        startPage = specialSooraChoice?.pageNumber
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if UIDevice.current.userInterfaceIdiom == .pad {
            safeTop.isActive = true
            superTop.isActive = false
            view.backgroundColor = .white
        }
        
        if LanguageManager.shared.currentLanguage == .ar {
            navigationController?.navigationBar.topItem?.title = "عودة"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    @objc func playPauseTapped() {
        getJuzNumber()
        if player == nil {
            playPauseButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 20)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slowmo"), style: .done, target: self, action: nil)
        }
        guard let audioPlayer = player else {
            
            let threeDigitSooraNumber = String(format: "%03d", specialSooraChoice?.soorahNumber ?? 1)
            let threeDigitPageNumber = String(format: "%03d", startPage ?? 1)
            
            if specialSooraChoice?.title != "Last Page" && startPage == specialSooraChoice?.pageNumber {
                myURL = "https://www.aswaatulqurraa.com/files/Surahs/Abu%20Bakr%20al-Shatri/\(threeDigitSooraNumber).mp3"
            } else if specialSooraChoice?.title != "Last Page" && startPage != specialSooraChoice?.pageNumber {
                myURL = "https://www.aswaatulqurraa.com/files/Pages/Abu%20Bakr%20al%20Shatri%20(15%20Liner)/\(juzNumber)/\(threeDigitPageNumber).mp3"
            } else {
                myURL = "https://www.aswaatulqurraa.com/files/Pages/Abu%20Bakr%20al%20Shatri%20(15%20Liner)/30/604.mp3"
            }
            URLSession.shared.dataTask(with: URL(string: "\(myURL)")!) { (data, response, error) in
                //DONE DOWNLOADING
                guard let data = data, error == nil else {
//                    print("Something went wrong")
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .done, target: self, action: #selector(self.playPauseTapped))
                    }
                    return
                }
                
                self.player = try? AVAudioPlayer(data: data, fileTypeHint: AVFileType.mp3.rawValue)
                self.player?.prepareToPlay()
                self.player?.play()
                self.player?.delegate = self
                DispatchQueue.main.sync {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .done, target: self, action: #selector(self.playPauseTapped))
                }
            }.resume()
            return
        }
        
        if audioPlayer.isPlaying {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .done, target: self, action: #selector(self.playPauseTapped))
            player?.pause()
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .done, target: self, action: #selector(self.playPauseTapped))
            player?.play()
        }
    }
    
    func getJuzNumber() {
        fixForPageOne()
        juzInitialNumber = (Double((startPage! - 1)) / 20).rounded(.up)
        juzNumber = Int(juzInitialNumber)
    }
    
    func fixForPageOne() {
        if startPage! == 1 {
            juzPageNumber = startPage! + 1
        } else if startPage! > 601 {
            juzPageNumber = startPage! - 4
        } else {
            juzPageNumber = startPage!
        }
        
    }
    
    func produceArray() {
        for pages in 1...Int(numberOfPages!){
            self.dailyPagesArray.insert(pages + startPage! - 1, at: 0)
        }
        self.currentViewControllerIndex = self.dailyPagesArray.count
        self.configurePageViewController()
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }

    func configurePageViewController() {
           
           guard let pageViewController = storyboard?.instantiateViewController(identifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else {
               return
           }
           
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
            pageViewController.modalTransitionStyle = .partialCurl
            pageViewController.isDoubleSided = true
            pageViewController.setViewControllers([nextViewController ,startingViewController], direction: .forward, animated: true)
            return .mid
        } else {
            pageViewController.modalTransitionStyle = .partialCurl
            pageViewController.isDoubleSided = false
            pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
            return .max
        }
    }
       
       func detailViewControllerAt(index: Int) -> DataViewController? {
           
        if index > dailyPagesArray.count || dailyPagesArray.count == 0 {
               return nil
           }
           
           guard let dataViewController = storyboard?.instantiateViewController(identifier: String(describing: DataViewController.self)) as? DataViewController else {
               return nil
           }
           
           if index == 0 {
               return nil
           }
           
        dataViewController.index = index
        dataViewController.quranPage = dailyPagesArray[index - 1]
           
           
           return dataViewController
       }
}

extension SoorahViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
        
        if currentIndex == 0 {
            return nil
        }
        
        startPage! += 1
        currentIndex -= 1
        
        if currentIndex == 1 && UIDevice.current.userInterfaceIdiom == .pad && ((UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape)!) && self.numberOfPages! % 2 != 0 {
        //            let startingViewController = detailViewControllerAt(index: currentViewControllerIndex)
                    let nextViewController = detailViewControllerAt(index: currentViewControllerIndex - 1)
                    let emptyViewController = EmptyViewController()
                    pageViewController.setViewControllers([emptyViewController, nextViewController!], direction: .reverse, animated: true)
                }
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
                
        let dataViewController = viewController as? DataViewController
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        if currentIndex == dailyPagesArray.count {
            return nil
        }
        
        startPage! -= 1
        currentIndex += 1
        
        currentViewControllerIndex = currentIndex
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        }
        var index = ((pageViewController.viewControllers!.first as! DataViewController).index)!
        index = numberOfPages! - index
        self.navigationItem.title = ""
        if player != nil && !player!.isPlaying {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player = nil
        }
    }
}
