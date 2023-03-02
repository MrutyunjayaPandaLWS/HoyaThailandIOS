//
//  HYT_OffersDetailsVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import WebKit

class HYT_OffersDetailsVC: UIViewController {

    @IBOutlet weak var productDetailsTextView: UITextView!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var offerNamesLbl: UILabel!
    @IBOutlet weak var offerDetailWebView: WKWebView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var offersImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 40
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

}
