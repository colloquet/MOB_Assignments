//
//  SearchResultCell.swift
//  ATM Finder
//
//  Created by Colloque Tsui on 24/8/15.
//  Copyright (c) 2015 Colloque Tsui. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet var bankNameLabel: UILabel!
    @IBOutlet var bankAddressLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
