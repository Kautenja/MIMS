//
//  MIMSTableViewCell.swift
//  MIMS
//
//  Created by Zachary Chandler on 4/22/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class MIMSTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel1: UILabel!
    @IBOutlet weak var detailLabel2: UILabel!
    @IBOutlet weak var detailLabel3: UILabel!
    @IBOutlet weak var sideInformationLabel: UILabel!
}
