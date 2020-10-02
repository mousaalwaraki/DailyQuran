//
//  FirstLaunchViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/28/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class FirstLaunchViewController: UIViewController {

    @IBOutlet weak var bismillahImage: UIImageView!
    @IBOutlet weak var pagesNumberChoiceButton: UIButton!
    @IBOutlet weak var numberChoiceStepper: UIStepper!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pageStartButton: UIButton!
    @IBOutlet weak var pageStartStepper: UIStepper!
    
    var changeDailyPagesAlertTitle = "Change Daily Pages"
    var changeDailyPagesAlertMessage = "How many pages would you like to read daily?"
    var pageStartAlertTitle = "Starting Page"
    var pageStartAlertMessage = "Which page would you like to start your reading at?"
    
    var alertCancel = "Cancel"
    var alertConfirm = "Confirm"
    
    
    @IBAction func engTapped(_ sender: Any) {
       LanguageManager.shared.setLanguage(language: .en, viewControllerFactory: { title -> UIViewController in
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          // instantiate the view controller that you want to show after changing the language.
          return storyboard.instantiateViewController(identifier: "FirstLaunchViewController")
        }) { view in
          // do custom animation
//          view.transform = CGAffineTransform(scaleX: 2, y: 2)
//          view.alpha = 0
        }
    }
    
    
    @IBAction func arTapped(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .ar, viewControllerFactory: { title -> UIViewController in
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          // instantiate the view controller that you want to show after changing the language.
          return storyboard.instantiateViewController(identifier: "FirstLaunchViewController")
        }) { view in
          // do custom animation
//          view.transform = CGAffineTransform(scaleX: 2, y: 2)
//          view.alpha = 0
        }
    }
    
    var numberOfPagesTextField:UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var startingPageTextField:UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var dailyNumberPages:Int = 1
    var startingPage:Int = 1
    
    var newNumberStart:Double = 1.0
    var newNumberDaily:Double = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagesNumberChoiceButton.setTitle("1", for: .normal)
        pageStartButton.setTitle("1", for: .normal)
        
        numberChoiceStepper.value = 1
        pageStartStepper.value = 1
        
        if self.traitCollection.userInterfaceStyle == .light {
            bismillahImage.image = bismillahImage.image?.invertedImage()
        }
    }
    
    func configurationTextField(textField: UITextField!) {
        if textField != nil {
            self.numberOfPagesTextField = textField!
            self.numberOfPagesTextField.keyboardType = .numberPad
            self.numberOfPagesTextField.text = "\(dailyNumberPages)"
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        newNumberDaily = sender.value
        pagesNumberChoiceButton.setTitle("\(Int(newNumberDaily))", for: .normal)
        if newNumberDaily != 0 && startingPage != 0 {
            UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 1
            }
        } else {
                UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 0
            }
        }
        dailyNumberPages = Int(newNumberDaily)
    }
    
    @IBAction func pagesNumberChoiceButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: changeDailyPagesAlertTitle.localiz(), message: changeDailyPagesAlertMessage.localiz(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertCancel.localiz(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: alertConfirm.localiz(), style: .default, handler:{ (UIAlertAction)in
            self.dailyNumberPages = Int(self.numberOfPagesTextField.text!)!
            self.pagesNumberChoiceButton.setTitle("\(self.dailyNumberPages)", for: .normal)
            self.numberChoiceStepper.value = Double(self.dailyNumberPages)
            self.numberChoiceStepper.stepValue = 1.0
            self.newNumberDaily = Double(self.numberOfPagesTextField.text!)!
            if self.dailyNumberPages != 0 {
                UIView.animate(withDuration: 0.3) {
                    self.doneButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.doneButton.alpha = 0
                }
            }
        }))
        alert.addTextField(configurationHandler: configurationTextField(textField: ))
        present(alert, animated:true)
    }
    
    func configurationTextField(text: UITextField!) {
        if text != nil {
            self.startingPageTextField = text!
            self.startingPageTextField.keyboardType = .numberPad
            self.startingPageTextField.text = "\(startingPage)"
        }
    }
    
    @IBAction func pagesStartStepperChanged(_ sender: UIStepper) {
        newNumberStart = sender.value
        pageStartButton.setTitle("\(Int(newNumberStart))", for: .normal)
        if newNumberStart != 0 && dailyNumberPages != 0{
            UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 1
            }
        }else {
                UIView.animate(withDuration: 0.3) {
                self.doneButton.alpha = 0
            }
        }
        startingPage = Int(newNumberStart)
    }
    
    @IBAction func pagesStartButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: pageStartAlertTitle.localiz(), message: pageStartAlertMessage.localiz(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertCancel.localiz(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: alertConfirm.localiz(), style: .default, handler:{ (UIAlertAction)in
            self.startingPage = Int(self.startingPageTextField.text!)!
            self.pageStartButton.setTitle("\(self.startingPage)", for: .normal)
            self.pageStartStepper.value = Double(self.startingPage)
            self.pageStartStepper.stepValue = 1.0
            self.newNumberStart = Double(self.startingPageTextField.text!)!
            if self.dailyNumberPages != 0 {
                UIView.animate(withDuration: 0.3) {
                    self.doneButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.doneButton.alpha = 0
                }
            }
        }))
        alert.addTextField(configurationHandler: configurationTextField(text: ))
        present(alert, animated:true)
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(Int(newNumberStart - 1), forKey: "pagesRead")
        UserDefaults.standard.set(Int(newNumberDaily), forKey: "dailyPages")
        let vc = storyboard?.instantiateViewController(identifier: "InitialViewController")
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }
    
}

