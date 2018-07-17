//
//  BDUpandDownTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 18/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDUpandDownTableViewCell: UITableViewCell {

    @IBOutlet weak var doctorNameLabel: UILabel!
    
    @IBOutlet weak var doctorImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var booktimeLabel: UILabel!
    @IBOutlet weak var hospitalnameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
   var colorBorder =  UIColor(red: 84/255.0, green: 175/255.0, blue: 152/255.0, alpha: 0.85)
    override func awakeFromNib() {
        super.awakeFromNib()
        statusLabel.layer.borderColor = colorBorder.cgColor
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.cornerRadius = 10
        doctorImage.layer.cornerRadius = doctorImage.frame.height / 2
        doctorImage.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
