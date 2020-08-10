//
//  SpecialSoarTableViewCell.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 6/2/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import UIKit

class SpecialSoarTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsLabel: UILabel!
    
    var item: SpecialSoarItems!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with item: SpecialSoarItems) {
        self.item = item
        
        settingsLabel.text = item.title
        
        isUserInteractionEnabled = true
        selectionStyle = .default
        accessoryType = .disclosureIndicator
    }
}
