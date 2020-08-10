//
//  DataTwoViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 6/10/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class DataTwoViewController: DataTypeViewController {

    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        rightImage.image = UIImage(named: "\(quranPage)")
        leftImage.image = UIImage(named: "\(quranPage + 1)")
    }

}

class DataTypeViewController: UIViewController {
    var index: Int?
    var quranPage: Int = 0
}
