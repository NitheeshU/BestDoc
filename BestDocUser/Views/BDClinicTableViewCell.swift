//
//  BDClinicTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 12/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDClinicTableViewCell: UITableViewCell {

    @IBOutlet weak var clinicImageView: UIImageView!
    
    @IBOutlet weak var clinicName: UILabel!
    
    @IBOutlet weak var clinicLocation: UILabel!
    
    @IBOutlet weak var clinicDistance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        clinicImageView.layer.cornerRadius = clinicImageView.frame.height / 2
        clinicImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
