//
//  DataViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/28/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet var bgView: UIView!
    @IBOutlet weak var quranImage: UIImageView!
    
    var fullScreen = false
    var index: Int?
    var quranPage: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.quranImage.image = UIImage(named: "\(self.quranPage)")
        if fullScreen {
            hideNavAndTab()
        } else {
            showNavAndTab()
        }
        if self.traitCollection.userInterfaceStyle == .dark && quranPage != 1 && quranPage != 2 {
            quranImage.backgroundColor = .black
            if UIDevice.current.userInterfaceIdiom == .phone {
                quranImage.alpha = 0.85
            }
            let darkQuranImage = quranImage.image?.invertedImage()
            quranImage.image = darkQuranImage
        } else {
            quranImage.backgroundColor = .white
            quranImage.alpha = 1
            quranImage.image = quranImage.image
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if fullScreen {
            hideNavAndTab()
        } else {
            showNavAndTab()
        }
    }
    
    override func viewDidLoad() {
        UserDefaults.standard.set(quranPage, forKey: "currentPage")
    }
        
    @IBAction func tap(_ sender: Any) {
        fullScreen = !fullScreen
        if fullScreen {
            hideNavAndTab()
        } else {
            showNavAndTab()
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func hideNavAndTab() {
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.tabBarController?.tabBar.alpha = 0
            self.setNeedsStatusBarAppearanceUpdate()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "FullScreen"), object: nil)
    }
    
    func showNavAndTab() {
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.tabBarController?.tabBar.alpha = 1
            self.setNeedsStatusBarAppearanceUpdate()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Non-FullScreen"), object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
            return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
}

