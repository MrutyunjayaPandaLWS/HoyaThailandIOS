//
//  HYT_S_PromotionTVCell.swift
//  Hoya Thailand
//
//  Created by syed on 23/02/23.
//

import UIKit


protocol S_PromotionListDelegate{
    func didTappedPromotionDetails(item: HYT_S_PromotionTVCell)
}
class HYT_S_PromotionTVCell: UITableViewCell {

    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var promotionDetailsLbl: UILabel!
    @IBOutlet weak var promotionsNameLbl: UILabel!
    @IBOutlet weak var validityDateLbl: UILabel!
    var promotionData : LtyPrgBaseDetails?
    var delegate : S_PromotionListDelegate?
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
}
