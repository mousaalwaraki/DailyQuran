//
//  RoundedButton.swift
//  QuranPersonalReader
//
//  Created by Marwan Elwaraki on 31/05/2020.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateCornerRadius()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCornerRadius()
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

}
