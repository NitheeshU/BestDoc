//
//  departmentTableViewCell.swift
//  BestDocUser
//
//  Created by nitheesh.u on 05/04/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import UIKit
protocol YourCellDelegates : class {
    func didTapButton(_ sender: UIButton)
    
}
class departmentTableViewCell: UITableViewCell {

    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var celltitle: UILabel!
    weak var cellDelegate: YourCellDelegates?
    var yourobj : (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.layer.cornerRadius = cellImage.frame.height / 2
        cellImage.clipsToBounds = true
        bookButton.backgroundColor = .clear
        bookButton.layer.cornerRadius = 5
        bookButton.layer.borderWidth = 2
        bookButton.layer.borderColor = UIColor(red: 0/255.0, green: 167/255.0, blue: 157/255.0, alpha: 0.85).cgColor
        // Initialization code
    }
    @IBAction func btnAction(_ sender: UIButton) {
        cellDelegate?.didTapButton(sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
