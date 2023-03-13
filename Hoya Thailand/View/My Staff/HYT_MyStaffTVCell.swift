//
//  HYT_MyStaffTVCell.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit
import LanguageManager_iOS

class HYT_MyStaffTVCell: UITableViewCell {

    @IBOutlet weak var membershipIdTitleLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusTitleLbl: UILabel!
    @IBOutlet weak var membershipIdLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var enrollmentDateLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var pointBalanceLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var staffNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        localization()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    private func localization(){
        pointBalanceLbl.text = "Point_Balance".localiz()
        enrollmentDateLbl.text = "Enrollment_Date".localiz()
        membershipIdTitleLbl.text = "membershipId".localiz()
        statusTitleLbl.text = "status".localiz()
    }

}
