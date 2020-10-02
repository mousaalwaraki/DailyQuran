//
//  CompletedQuranViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 6/8/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class CompletedQuranViewController: UIViewController {
    
    var flyingEmojiLabels: [UILabel] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        createEmojis()
        animateEmojisToTop()
        // Do any additional setup after loading the view.
    }
    
    func createEmojis() {
           
           let emojiCount = 50
           
           for index in 0...emojiCount {
               let xPosition = (view.frame.width / CGFloat(emojiCount)) * CGFloat(index)
               let yPosition = view.frame.height + 150
               
               let emojiLabel = UILabel(frame: CGRect(x: xPosition, y: yPosition, width: 80, height: 80))
               emojiLabel.text = "🎉"
               emojiLabel.font = emojiLabel.font.withSize(60)
               
               view.addSubview(emojiLabel)
               flyingEmojiLabels.append(emojiLabel)
           }
       }
       
       func animateEmojisToTop() {
           
           for emojiLabel in flyingEmojiLabels {
               
               UIView.animate(withDuration: TimeInterval(CGFloat.random(in: 1..<3)), animations: {
                   let minXRange = emojiLabel.frame.minX - 100
                   let maxXRange = emojiLabel.frame.minX + 100
                   let xPosition = CGFloat.random(in: minXRange...maxXRange)
                   
                   emojiLabel.frame = CGRect(x: xPosition, y: -100, width: emojiLabel.frame.width, height: emojiLabel.frame.height)
               }) { _ in
                   emojiLabel.removeFromSuperview()
               }
           }
       }
       
    
    @IBAction func duaaButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DuaaViewController")
        UserDefaults.standard.set(1000, forKey: "todaysDate")
        self.present(vc, animated: true)
//        UIApplication.shared.windows.first?.rootViewController =  vc
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FirstLaunchViewController")
        UserDefaults.standard.set(1, forKey: "dailyPages")
        UserDefaults.standard.set(0, forKey: "todaysDate")
        self.present(vc, animated: true)
    }
    
}
