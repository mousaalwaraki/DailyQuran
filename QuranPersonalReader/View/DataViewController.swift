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
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var fullScreen = UserDefaults.standard.value(forKey: "FullScreen") as? Bool ?? false
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
        UIView.animate(withDuration: 0.3) { [self] in
            fullScreen = true
            UserDefaults.standard.set(fullScreen, forKey: "FullScreen")
            navigationController?.navigationBar.alpha = 0
            tabBarController?.tabBar.alpha = 0
            setNeedsStatusBarAppearanceUpdate()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "FullScreen"), object: nil)
    }
    
    func showNavAndTab() {
        UIView.animate(withDuration: 0.3) { [self] in
            fullScreen = false
            UserDefaults.standard.set(fullScreen, forKey: "FullScreen")
            navigationController?.navigationBar.alpha = 1
            tabBarController?.tabBar.alpha = 1
            setNeedsStatusBarAppearanceUpdate()
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

