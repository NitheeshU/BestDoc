//
//  BDclinicHoursTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/04/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDclinicHoursTableViewCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var sessionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
