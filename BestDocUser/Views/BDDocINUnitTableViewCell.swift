//
//  BDDocINUnitTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 13/07/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDDocINUnitTableViewCell: UITableViewCell {

    @IBOutlet weak var docProfileImage: UIImageView!
    @IBOutlet weak var docname: UILabel!
    
    @IBOutlet weak var sessionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        docProfileImage.layer.cornerRadius = docProfileImage.frame.height / 2
        docProfileImage.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
