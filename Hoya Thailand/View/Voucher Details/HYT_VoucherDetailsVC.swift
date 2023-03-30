//
//  HYT_VoucherDetailsVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import WebKit
import Toast_Swift
import LanguageManager_iOS

class HYT_VoucherDetailsVC: BaseViewController {

    @IBOutlet weak var expireDateLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var availableBalanceTitle: UILabel!
    @IBOutlet weak var availableBalanceLbl: UILabel!
    @IBOutlet weak var voucherDetailsTextView: UITextView!
    @IBOutlet weak var rangeAmountLbl: UILabel!
    @IBOutlet weak var voucherDetails: WKWebView!
    @IBOutlet weak var redeemBtn: UIButton!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var voucherName: UILabel!
    @IBOutlet weak var voucherImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    var pointExpireDetails = [eVoucherPointExpModel]()
    var productDetails : ObjCatalogueList1?
    var VM = HYT_VoucherDetailsVM()
    var currentDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        amountTF.keyboardType = .numberPad
        localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        availableBalanceLbl.text = "\(redeemablePointBal)"
        if pointExpireDetails.count != 0{
            pointsLbl.text = "\(pointExpireDetails[0].attributeId ?? 0) Points"
            expireDateLbl.text = "will Expire on : \(pointExpireDetails[0].attributeNames ?? "0")"
        }
        setUpdata()
    }
    
    @IBAction func didTappedRedeemBtn(_ sender: UIButton) {
        if amountTF.text?.count == 0{
            self.view.makeToast("Enter amount", duration: 2.0, position: .center)
        }else if Int(productDetails?.min_points ?? "0") ?? 0 <= Int(amountTF.text ?? "") ?? 0 && Int(productDetails?.max_points ?? "0") ?? 0 >= Int(amountTF.text ?? "") ?? 0{
            var redeemValue = Int(amountTF.text ?? "0")
            if redeemValue == 0{
                self.view.makeToast("Redeem value shouldn't be 0", duration: 2.0, position: .center)
                amountTF.text = ""
            }else{
                let parameter : [String : Any] = [
                              "ActionType": 51,
                              "ActorId": userId,
                              "CountryCode": "THA",
                              "CountryID": "\(productDetails?.countryID ?? 0)",
                              "lstCatalogueMobileApiJson": [
                                [
                                    "CatalogueId": "\(productDetails?.catalogueId ?? 0)",
                                    "CountryCurrencyCode": "THB",
                                    "DeliveryType": "in_store",
                                    "HasPartialPayment": false,
                                    "NoOfPointsDebit": "\(amountTF.text ?? "0")",
                                    "NoOfQuantity": 1,
                                    "PointsRequired": "\(amountTF.text ?? "0")",
                                    "ProductCode": "\(productDetails?.productCode ?? "0")",
                                    "ProductImage": "\(productDetails?.productImage ?? "")",
                                    "ProductName": "\(productDetails?.productName ?? "")",
                                    "RedemptionDate": currentDate,
                                    "RedemptionId": "\(productDetails?.redemptionId ?? 0)",
                                    "Status": 0,
                                    "VendorId": "\(productDetails?.vendorId ?? 0)",
                                    "VendorName": "WOGI"
                                ]
                            ],
                              "ReceiverName": firstName ?? "",
                              "ReceiverEmail": customerEmail ?? "",
                              "ReceiverMobile": customerMobileNumber ?? "",
                              "SourceMode": 4
                        

                ]
                self.VM.voucherRedeemptionApi(parameter: parameter)
            }

        }else{
            self.view.makeToast("Enter amount between min & max range", duration: 2.0, position: .center)
            amountTF.text = ""
        }
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func setUpdata(){
        voucherDetailsTextView.text = productDetails?.termsCondition
        voucherImage.sd_setImage(with: URL(string: productDetails?.productImage ?? ""), placeholderImage: UIImage(named: "ic_default_img (1)"))
        voucherName.text = productDetails?.productName
        rangeAmountLbl.text = "\(productDetails?.min_points ?? "0") - \(productDetails?.max_points ?? "0")"
    }

    func localization(){
        titleLbl.text = "e_voucher".localiz()
        availableBalanceTitle.text = "availableBal".localiz()
        redeemBtn.setTitle("redeem".localiz(), for: .normal)
        
    }
    
}
