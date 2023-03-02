//
//  HYT_QueryTVCell.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit

class HYT_QueryTVCell: UITableViewCell {

    @IBOutlet weak var querySummeryLbl: UILabel!
    @IBOutlet weak var queryStatusLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var queryDateLbl: UILabel!
    @IBOutlet weak var queryRefNoLbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
