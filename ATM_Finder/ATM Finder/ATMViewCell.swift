//
//  ATMViewCell.swift
//  ATM Finder
//
//  Created by Colloque Tsui on 17/8/15.
//  Copyright (c) 2015 Colloque Tsui. All rights reserved.
//

import UIKit

class ATMViewCell: UITableViewCell {

    @IBOutlet weak var cellTypeLabel: UILabel!
    @IBOutlet weak var cellDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
