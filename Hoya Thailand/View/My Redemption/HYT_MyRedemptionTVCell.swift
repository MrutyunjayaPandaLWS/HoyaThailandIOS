//
//  HYT_MyRedemptionTVCell.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit


protocol myRedeemptionDelegate{
    func downloadVoucher(item: HYT_MyRedemptionTVCell)
}

class HYT_MyRedemptionTVCell: UITableViewCell {

    @IBOutlet weak var downloadVoucherViewHeight: NSLayoutConstraint!
    @IBOutlet weak var downloadImageLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusTitleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateTitleLbl: UILabel!
    @IBOutlet weak var voucherNameLbl: UILabel!
    @IBOutlet weak var voucherNameTitleLbl: UILabel!
    @IBOutlet weak var pointsTitleLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    var downloadVoucher:String = ""
    var delegate : myRedeemptionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTappedDownloadVoucher(_ sender: UIButton) {
        delegate?.downloadVoucher(item: self)
    }
    
}
