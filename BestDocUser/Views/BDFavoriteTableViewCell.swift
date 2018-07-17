//
//  BDFavoriteTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 17/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
protocol nextCellDelegate : class {
    func didTapButton(_ sender: UIButton)
    
}
class BDFavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var Selectionview: UIView!
    @IBOutlet weak var drprofileImage: UIImageView!
    @IBOutlet weak var qualification: UILabel!
    @IBOutlet weak var speciality: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    weak var cellDelegate: nextCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
       // Selectionview.layer.addBorder(edge: .bottom, color: UIColor.lightGray, width:Selectionview.frame.width, thickness: 1)
        drprofileImage.layer.cornerRadius = drprofileImage.frame.height / 2
        drprofileImage.clipsToBounds = true
        // Initialization code
    }

    @IBAction func bookAction(_ sender: UIButton) {
        cellDelegate?.didTapButton(sender)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
