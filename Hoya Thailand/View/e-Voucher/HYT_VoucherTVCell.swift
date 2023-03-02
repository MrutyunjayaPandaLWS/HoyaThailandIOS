//
//  HYT_VoucherTVCell.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit

protocol RedeemVoucherDelegate{
    func didTappedRedeemVoucherBtn(item: HYT_VoucherTVCell)
}

class HYT_VoucherTVCell: UITableViewCell {

    @IBOutlet weak var redeemBtn: UIButton!
    @IBOutlet weak var rangeValueLbl: UILabel!
    @IBOutlet weak var rangeLbl: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var voucherNameLbl: UILabel!
    @IBOutlet weak var voucherImage: UIImageView!
    var delegate: RedeemVoucherDelegate?
    var voucherDetails : ObjCatalogueList1?
    override func awakeFromNib() {
        super.awakeFromNib()
        amountTF.keyboardType = .numberPad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didTappedRedeemBtn(_ sender: UIButton) {
        delegate?.didTappedRedeemVoucherBtn(item: self)
    }
    
}
