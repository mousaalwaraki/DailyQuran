//
//  SettingsViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/28/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class DoneReadingViewController: UIViewController {
    
    var flyingEmojiLabels: [UILabel] = []
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        createEmojis()
//        animateEmojisToTop()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        createEmojis()
        animateEmojisToTop()
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
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "InitialViewController")
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }
}
