//
//  DataViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/28/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

var fullScreen = false

protocol DataViewControllerDelegate {
    func setBGColor(to color: UIColor)
}

class DataViewController: UIViewController {

    @IBOutlet weak var quranImage: UIImageView!
    var delegate: DataViewControllerDelegate?
    
    var index: Int?
    var quranPage: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fullScreen {
            zoomIn()
        } else {
            zoomOut()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if fullScreen {
            zoomIn()
        } else {
            zoomOut()
        }
    }
    
    @IBAction func tap(_ sender: Any) {
        fullScreen = !fullScreen
        if fullScreen {
            zoomIn()
            delegate?.setBGColor(to: UIColor(red: 0.89, green: 0.98, blue: 1.00, alpha: 1.00))
        } else {
            zoomOut()
            delegate?.setBGColor(to: .white)
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func zoomIn() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.view.backgroundColor = .white
        } else {
            view.backgroundColor = UIColor(red: 0.89, green: 0.98, blue: 1.00, alpha: 1.00)
        }
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.tabBarController?.tabBar.alpha = 0
            self.quranImage.image = UIImage(named: "\(self.quranPage)")
            self.setNeedsStatusBarAppearanceUpdate()
            
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            //don't zoom in if on ipad
            return
        }
        
        if self.quranPage == 1 || self.quranPage == 2 {
            let size = CGSize(width: 650, height: 1200)
            let newImage = self.quranImage.image?.crop(to: size)
            self.quranImage.image = newImage
            self.view.layoutIfNeeded()
            self.view.reloadInputViews()
            return
        }
            let size = CGSize(width: 585, height: 945)
            let newImage = self.quranImage.image?.crop(to: size)
            self.quranImage.image = newImage
            self.view.layoutIfNeeded()
            self.view.reloadInputViews()
        
    }
    
    func zoomOut() {
        view.backgroundColor = .white
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.tabBarController?.tabBar.alpha = 1
            self.quranImage.image = UIImage(named: "\(self.quranPage)")
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.view.layoutIfNeeded()
        self.view.reloadInputViews()
    }
    
    override var prefersStatusBarHidden: Bool {
            return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
}

extension UIImage {

func crop(to:CGSize) -> UIImage {

    guard let cgimage = self.cgImage else { return self }

    let contextImage: UIImage = UIImage(cgImage: cgimage)

    guard let newCgImage = contextImage.cgImage else { return self }

    let contextSize: CGSize = contextImage.size

    //Set to square
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    let cropAspect: CGFloat = to.width / to.height

    var cropWidth: CGFloat = to.width
    var cropHeight: CGFloat = to.height

    if to.width > to.height { //Landscape
        cropWidth = contextSize.width
        cropHeight = contextSize.width / cropAspect
        posY = (contextSize.height - cropHeight) / 2
    } else if to.width < to.height { //Portrait
        posX = (contextSize.width - cropWidth) / 2
        posY = (contextSize.height - cropHeight) / 2 + 5
    } else { //Square
        if contextSize.width >= contextSize.height { //Square on landscape (or square)
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        }else{ //Square on portrait
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        }
    }

    let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

    // Create bitmap image from context using the rect
    guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

    // Create a new image based on the imageRef and rotate back to the original orientation
    let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

    UIGraphicsBeginImageContextWithOptions(to, false, self.scale)
    cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
    let resized = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return resized ?? self
  }
}
