//
//  BDDoctorReviewTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/04/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDDoctorReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var reviewimageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
