//
//  HYT_DashboardMenuTVCell.swift
//  Hoya Thailand
//
//  Created by syed on 15/02/23.
//

import UIKit

class HYT_DashboardMenuTVCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var menuLogo: UIImageView!
    @IBOutlet weak var menuItemNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
