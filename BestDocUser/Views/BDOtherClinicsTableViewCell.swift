//
//  BDOtherClinicsTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 18/04/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDOtherClinicsTableViewCell: UITableViewCell {

    @IBOutlet weak var clinicAddress: UILabel!
    @IBOutlet weak var ClinicName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
