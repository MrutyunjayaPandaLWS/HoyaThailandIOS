//
//  HYT_OffersTVCell.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import LanguageManager_iOS

protocol OffersDelegate{
    func didTappedViewBtn(item: HYT_OffersTVCell)
}
class HYT_OffersTVCell: UITableViewCell {

    @IBOutlet weak var validDate: UILabel!
    @IBOutlet weak var validTilllbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var offersName: UILabel!
    @IBOutlet weak var offersImage: UIImageView!
    var delegate: OffersDelegate?
    var offersData: LstPromotionJsonList?
    override func awakeFromNib() {
        super.awakeFromNib()
        localization()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func selectViewBtn(_ sender: UIButton) {
        delegate?.didTappedViewBtn(item: self)
    }
    
    func localization(){
        viewBtn.setTitle("View".localiz(), for: .normal)
        validTilllbl.text = "Valid_till".localiz()
        
    }
}
