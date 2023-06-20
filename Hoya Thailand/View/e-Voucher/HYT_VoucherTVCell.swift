//
//  HYT_VoucherTVCell.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import LanguageManager_iOS

protocol RedeemVoucherDelegate{
    func didTappedRedeemVoucherBtn(item: HYT_VoucherTVCell)
    func didTappedSelectAmountbtn(item: HYT_VoucherTVCell)
}

class HYT_VoucherTVCell: UITableViewCell {

    @IBOutlet weak var enterAmountView: UIView!
    @IBOutlet weak var selectAmountLbl: UILabel!
    @IBOutlet weak var dropdownIconView: UIView!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var redeemBtn: UIButton!
    @IBOutlet weak var rangeValueLbl: UILabel!
    @IBOutlet weak var rangeLbl: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var voucherNameLbl: UILabel!
    @IBOutlet weak var voucherImage: UIImageView!
    var delegate: RedeemVoucherDelegate?
    var voucherDetails : ObjCatalogueList1?
    var vouchersdata = [ObjCatalogueList1]()
    var selectedPoints = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        amountTF.keyboardType = .numberPad
        localization()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didTappedRedeemBtn(_ sender: UIButton) {
        delegate?.didTappedRedeemVoucherBtn(item: self)
    }
    
    func localization(){
        redeemBtn.setTitle("redeem".localiz(), for: .normal)
    }
    
    @IBAction func didTappedAmountBtn(_ sender: Any) {
        delegate?.didTappedSelectAmountbtn(item: self)
    }
    
}
