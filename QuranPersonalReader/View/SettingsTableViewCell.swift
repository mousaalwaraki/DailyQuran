//
//  SettingsTableViewCell.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 5/29/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    var item: SettingsItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingsImageView.layer.cornerRadius = 6
    }
    
    func setup(with item: SettingsItem) {
        self.item = item
        
        settingsLabel.text = item.title
        settingsImageView.image = item.image?.imageWithInsets(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))?.withRenderingMode(.alwaysTemplate)
        settingsImageView.backgroundColor = item.color
        
            settingsSwitch.isHidden = true
            isUserInteractionEnabled = true
            selectionStyle = .default
            accessoryType = .disclosureIndicator
    }
}
