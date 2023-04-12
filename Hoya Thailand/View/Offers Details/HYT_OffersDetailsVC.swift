//
//  HYT_OffersDetailsVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import SDWebImage
import LanguageManager_iOS
import WebKit

class HYT_OffersDetailsVC: UIViewController {

    @IBOutlet weak var productDetailsTextView: UITextView!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var offerNamesLbl: UILabel!
    @IBOutlet weak var offerDetailWebView: WKWebView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var offersImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    var offersDetails : LstPromotionJsonList?
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 40
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        productDetailsTextView.isEditable = false
        setup()
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func setup(){
        offersImage.sd_setImage(with: URL(string: PROMO_IMG1 + (offersDetails?.proImage?.dropFirst(3) ?? "")), placeholderImage: UIImage(named: "ic_default_img (1)"))
        offerNamesLbl.text = offersDetails?.promotionName
        discountLbl.text = offersDetails?.proShortDesc
        productDetailsTextView.text = offersDetails?.proLongDesc
    }

    func localization(){
        titleLbl.text = "".localiz()
    }
    
}
