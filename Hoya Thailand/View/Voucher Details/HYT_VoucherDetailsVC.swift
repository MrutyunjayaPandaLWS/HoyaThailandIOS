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

class HYT_VoucherDetailsVC: BaseViewController, pointsDelegate {

    
    func selectPointsDidTap(_ VC: RedeemQuantity_VC) {
        self.selectedPoints = VC.selectedpoints
        self.productcodeselected = VC.productCodefromPrevious
        print(VC.selectedpoints)
        print(VC.productCodefromPrevious)
        print(productcodeselected,"sdkjdn")
        self.productDetails?.selectedAmount = VC.selectedpoints
        self.selectAmountLbl.text = "\(VC.selectedpoints)"

    }
    

    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var selectAmountLbl: UILabel!
    @IBOutlet weak var dropDownAmountView: UIView!
    @IBOutlet weak var amountView: UIView!
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
    var totalRedeemPoint = 0
    var pointExpireDetails = [eVoucherPointExpModel]()
    var productDetails : ObjCatalogueList1?
    var VM = HYT_VoucherDetailsVM()
    var currentDate = ""
    var tomorrowDate = ""
    var productcodeselected = ""
    var selectedPoints = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        amountTF.keyboardType = .numberPad
        localization()
        voucherDetailsTextView.isEditable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dashboardApi()
//        availableBalanceLbl.text = "\(redeemablePointBal)"
        if pointExpireDetails.count != 0{
            if (pointExpireDetails[0].attributeId ?? 0) != 0{
                pointsView.isHidden = false
                pointsLbl.text = "\(pointExpireDetails[0].attributeId ?? 0) Points"
                if pointExpireDetails[0].attributeNames?.count != 0{
                    expireDateLbl.text = "will Expire on : \(pointExpireDetails[0].attributeNames ?? "")"
                }else{
                    expireDateLbl.text = "will Expire on :\(tomorrowDate)"
                }
            }else{
                pointsView.isHidden = true
            }
            
        }else{
            pointsView.isHidden = true
//            expireDateLbl.text = "will Expire on : \(tomorrowDate)"
        }
        setUpdata()
    }
    
    @IBAction func didTappedSelectAmountBtn(_ sender: UIButton) {
        DispatchQueue.main.async{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RedeemQuantity_VC") as? RedeemQuantity_VC
            vc!.productCodefromPrevious = self.productDetails?.productCode ?? ""
            vc!.delegate = self
            vc!.modalPresentationStyle = .overCurrentContext
            vc!.modalTransitionStyle = .crossDissolve
            self.present(vc!, animated: true, completion: nil)
        
        }
    }
    
    
    @IBAction func didTappedRedeemBtn(_ sender: UIButton) {
      
        if productDetails?.product_type == 1{
            let EnterAmount = Int(amountTF.text ?? "0")
            if amountTF.text?.count == 0{
                self.view.makeToast("Enter amount", duration: 2.0, position: .center)
            }else if Int(productDetails?.min_points ?? "0") ?? 0 <= Int(amountTF.text ?? "") ?? 0 && Int(productDetails?.max_points ?? "0") ?? 0 >= Int(amountTF.text ?? "") ?? 0{
                let redeemValue = Int(amountTF.text ?? "0")
                if redeemValue == 0{
                    self.view.makeToast("Redeem value shouldn't be 0", duration: 2.0, position: .center)
                    amountTF.text = ""
                }else  if totalRedeemPoint < EnterAmount!{
                    self.view.makeToast("insufficient Redeemable Balance", duration: 2.0, position: .center)
                    amountTF.text = ""
                }else{
                    redeemVoucher(countryID: productDetails?.countryID ?? 0, catalogueID: productDetails?.catalogueId ?? 0, amount: self.amountTF.text ?? "0", productCode: productDetails?.productCode ?? "0", productImage: productDetails?.productImage ?? "", productName: productDetails?.productName ?? "", currentDate: currentDate, venderID: productDetails?.vendorId ?? 0, redemptionId: productDetails?.redemptionId ?? 0)
                }
                
            }else{
                self.view.makeToast("Enter amount between min & max range", duration: 2.0, position: .center)
                amountTF.text = ""
            }
        }else{
            if self.selectAmountLbl.text == "Select Amount"{
                self.view.makeToast("Please Select amount", duration: 2.0, position: .center)
            }else{
                var redeemValue = Int(self.selectAmountLbl.text ?? "0")
                if redeemValue == 0{
                    self.view.makeToast("Redeem value shouldn't be 0", duration: 2.0, position: .center)
                    self.selectAmountLbl.text = "Select Amount"
                }else if totalRedeemPoint < redeemValue!{
                    self.view.makeToast("insufficient Redeemable Balance", duration: 2.0, position: .center)
                    self.selectAmountLbl.text = "Select Amount"
                }else{
                    redeemVoucher(countryID: productDetails?.countryID ?? 0, catalogueID: productDetails?.catalogueId ?? 0, amount: self.selectAmountLbl.text ?? "0", productCode: productDetails?.productCode ?? "0", productImage: productDetails?.productImage ?? "", productName: productDetails?.productName ?? "", currentDate: currentDate, venderID: productDetails?.vendorId ?? 0, redemptionId: productDetails?.redemptionId ?? 0)
                }
            }

        }
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func dashboardApi(){
        let parameter : [String : Any] = [
                "ActorId": userId
        ]
        self.VM.dashBoardApi(parameter: parameter)
    }
    
    func setUpdata(){
        voucherDetailsTextView.text = productDetails?.productDesc
        voucherImage.sd_setImage(with: URL(string: productDetails?.productImage ?? ""), placeholderImage: UIImage(named: "ic_default_img (1)"))
        voucherName.text = productDetails?.productName
        
        if productDetails?.product_type == 1{
            dropDownAmountView.isHidden = true
            amountView.isHidden = false
            rangeAmountLbl.isHidden = false
            rangeAmountLbl.text = "\(productDetails?.min_points ?? "0") - \(productDetails?.max_points ?? "0")"
        }else{
            dropDownAmountView.isHidden = false
            amountView.isHidden = true
            rangeAmountLbl.text = ""
        }
    }

    func localization(){
        titleLbl.text = "e_voucher".localiz()
        availableBalanceTitle.text = "availableBal".localiz()
        redeemBtn.setTitle("redeem".localiz(), for: .normal)
        
    }
    
    func redeemVoucher(countryID: Int,catalogueID: Int,amount: String,productCode: String,productImage: String,productName: String,currentDate: String,venderID: Int,redemptionId: Int){
        let parameter : [String : Any] = [
                      "ActionType": 51,
                      "ActorId": userId,
                      "CountryCode": "THA",
                      "CountryID": "\(countryID)",
                      "lstCatalogueMobileApiJson": [
                        [
                            "CatalogueId": "\(catalogueID)",
                            "CountryCurrencyCode": "THB",
                            "DeliveryType": "in_store",
                            "HasPartialPayment": false,
                            "NoOfPointsDebit": "\(amount)",
                            "NoOfQuantity": 1,
                            "PointsRequired": "\(amount)",
                            "ProductCode": "\(productCode)",
                            "ProductImage": "\(productImage)",
                            "ProductName": "\(productName)",
                            "RedemptionDate": currentDate,
                            "RedemptionId": "\(redemptionId)",
                            "Status": 0,
                            "VendorId": "\(venderID)",
                            "VendorName": "WOGI"
                        ] as [String : Any]
                    ],
                      "ReceiverName": firstName ?? "",
                      "ReceiverEmail": customerEmail ?? "",
                      "ReceiverMobile": customerMobileNumber ?? "",
                      "SourceMode": 4
        ]
        self.VM.voucherRedeemptionApi(parameter: parameter)
    }
    
   
    
}
