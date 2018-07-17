//
//  BDHospitalsTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 12/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit

class BDHospitalsTableViewCell: UITableViewCell {

    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var locatioName: UILabel!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var hospitalimageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        hospitalimageView.layer.cornerRadius = hospitalimageView.frame.height / 2
        hospitalimageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
