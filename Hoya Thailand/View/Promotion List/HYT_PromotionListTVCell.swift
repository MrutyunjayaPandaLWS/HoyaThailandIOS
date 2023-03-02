//
//  HYT_PromotionListTVCell.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit

protocol PromotionListDelegate{
    func didTappedPromotionDetails(item: HYT_PromotionListTVCell)
    func didTappedPromotionClaim(item: HYT_PromotionListTVCell)
}

class HYT_PromotionListTVCell: UITableViewCell {

    @IBOutlet weak var validityDateLbl: UILabel!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var claimBtn: UIButton!
    @IBOutlet weak var promotionDetailsLbl: UILabel!
    @IBOutlet weak var promotionNameLbl: UILabel!
    var delegate : PromotionListDelegate?
    var promotionData : LtyPrgBaseDetails?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTappedDetailsBtn(_ sender: UIButton) {
        delegate?.didTappedPromotionDetails(item: self)
    }
    
    @IBAction func didTappedClaimBtn(_ sender: UIButton) {
        delegate?.didTappedPromotionClaim(item: self)
    }
}
