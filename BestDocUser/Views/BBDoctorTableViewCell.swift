//
//  BBDoctorTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 12/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
import  Alamofire
protocol YourCellDelegate : class {
    func didTapButton(_ sender: UIButton)
     func didTapButtonCall(_ sender: UIButton)
}
class BBDoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var experinceLabel: UILabel!
    
    @IBOutlet weak var doctorIcon: UIImageView!
    @IBOutlet weak var HosptalName: UILabel!
    @IBOutlet weak var doctorSpecialty: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    weak var cellDelegate: YourCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        doctorIcon.layer.cornerRadius = doctorIcon.frame.height / 2
        doctorIcon.clipsToBounds = true
        // Initialization code
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        cellDelegate?.didTapButtonCall(sender)
    }
    
    
    @IBAction func bookAction(_ sender: UIButton) {
         cellDelegate?.didTapButton(sender)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//extension SAIHomeTableViewCell{
//    func setCollectionViewDataSourceDelegate
//        <D: UICollectionViewDataSource & UICollectionViewDelegate>
//        (dataSourceDelegate: D, forRow row: Int) {
//        categoryCollectionView.delegate = dataSourceDelegate
//        categoryCollectionView.dataSource = dataSourceDelegate
//        categoryCollectionView.tag = row
//        categoryCollectionView.reloadData()
//    }


