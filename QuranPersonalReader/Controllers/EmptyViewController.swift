//
//  EmptyViewController.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 6/28/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(true, forKey: "LastPage")
    }

    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "LastPage")
    }
    
}
