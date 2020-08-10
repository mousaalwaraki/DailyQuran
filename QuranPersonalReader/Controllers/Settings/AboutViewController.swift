//
//  AboutViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/29/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beautifyVC()
        setParagraphText()
        
        view.layoutIfNeeded()
        view.reloadInputViews()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        view.layoutIfNeeded()
        }
    
    @IBAction func tappedShare(_ sender: Any) {
        
        guard let url = URL(string: "https://apps.apple.com/gb/app/daily-quran-bulid-a-habit/id1516253962") else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
          if UIDevice.current.userInterfaceIdiom == .pad {
                          activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: Int(self.view.bounds.midX), y: Int(self.view.bounds.maxY - (navigationController?.tabBarController?.tabBar.bounds.maxY)! - shareButton.bounds.maxY) - 15, width: 0, height: 0)
                          activityViewController.popoverPresentationController?.permittedArrowDirections = [.down]
                      }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func beautifyVC() {
        title = "About"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView?.largeContentTitle = "About"
        view.reloadInputViews()
        shareButton.layer.cornerRadius = 12
    }
    
    func setParagraphText() {
        aboutText.text = "At Daily Quran we belive that the Quran holds immense value for mankind not only for religious purposes but also to improve day-to-day lives of humans, this is highlighted by Prophet Muhammed (PBUH) when he said: \n\n'Whenever mischief and seditions surround you like a part of the darkness of the night then (take refuge and) go towards the Holy Quran.' \n\nThere is importance in the Quran, not only reciting the Quran in a consistent matter, but also to encourage correct recitations. This is evident in the Quran: \n\n'…And recite the Quran with measured recitation. [Quran 73:4] \n\nalso when Prophet Muhammed (PBUH) said: \n\n'Read the Quran, for verily it will come on the Day of Standing as an intercessor for its companions.' \n\n'These hearts rust just as iron rusts; and indeed they are polished through the recitation of the Qur’an.' \n\nThis is why we at Daily Quran believe not only in encouraging daily reading, but also in giving the option of following a sheikh while reciting in order to correct mistakes and improve quality of recitations."
    }
}
