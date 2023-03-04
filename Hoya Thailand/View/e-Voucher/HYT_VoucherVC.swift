//
//  HYT_VoucherVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import Toast_Swift
import SDWebImage

class HYT_VoucherVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,RedeemVoucherDelegate {
    
    func didTappedRedeemVoucherBtn(item: HYT_VoucherTVCell) {
        if item.amountTF.text?.count == 0{
            self.view.makeToast("Enter amount", duration: 2.0, position: .center)
        }else if Int(item.voucherDetails?.min_points ?? "0") ?? 0 < Int(item.amountTF.text ?? "") ?? 0 && Int(item.voucherDetails?.max_points ?? "0") ?? 0 > Int(item.amountTF.text ?? "") ?? 0{
            
            let parameter : [String : Any] = [
                          "ActionType": 51,
                          "ActorId": userId,
                          "CountryCode": "THA",
                          "CountryID": "\(item.voucherDetails?.countryID ?? 0)",
                          "lstCatalogueMobileApiJson": [
                            [
                                "CatalogueId": "\(item.voucherDetails?.catalogueId ?? 0)",
                                "CountryCurrencyCode": "THB",
                                "DeliveryType": "in_store",
                                "HasPartialPayment": false,
                                "NoOfPointsDebit": "\(item.amountTF.text ?? "0")",
                                "NoOfQuantity": 1,
                                "PointsRequired": "\(item.amountTF.text ?? "0")",
                                "ProductCode": "\(item.voucherDetails?.productCode ?? "0")",
                                "ProductImage": "\(item.voucherDetails?.productImage ?? "")",
                                "ProductName": "\(item.voucherDetails?.productName ?? "")",
                                "RedemptionDate": currentDate,
                                "RedemptionId": "\(item.voucherDetails?.redemptionId ?? 0)",
                                "Status": 0,
                                "VendorId": "\(item.voucherDetails?.vendorId ?? 0)",
                                "VendorName": "WOGI"
                            ]
                        ],
                          "ReceiverName": firstName ?? "",
                          "ReceiverEmail": customerEmail ?? "",
                          "ReceiverMobile": customerMobileNumber ?? "",
                          "SourceMode": 4
                    

            ]
            self.VM.voucherRedeemptionApi(parameter: parameter)
            
            item.amountTF.text = ""
        }else{
            self.view.makeToast("Enter amount between min & max range", duration: 2.0, position: .center)
        }
    }
    
 

    @IBOutlet weak var emptyMessageLbl: UILabel!
    @IBOutlet weak var voucherTableView: UITableView!
    @IBOutlet weak var expireDateLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var availableBalanceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var VM = HYT_VoucherListVM()
    var fromDate = ""
    var toDate = ""
    var currentDate = ""
    var startIndex = 1
    var noOfElement = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        emptyMessageLbl.isHidden = true
        voucherTableView.delegate = self
        voucherTableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        balanceLbl.text = "\(redeemablePointBal)"
        getVoucherList_Api()
        getPointExpire_Api()
        currentdate()
    }
    
    @IBAction func didtappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func currentdate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let now = Date()
        let dateString = formatter.string(from:now)
        NSLog("%@", dateString)
        print("current date",dateString)
        currentDate = dateString
    }
    func getVoucherList_Api(){
            let parameter : [String : Any] = [
                
                    "ActionType": 6,
                    "ActorId": userId,
                     "StartIndex": startIndex,
                    "NoOfRows": "10",
                    "ObjCatalogueDetails": [
                        "CatalogueType": 4
                    ],
                    "Vendor":"WOGI"
            ]
        
        self.VM.voucherListApi(parameter: parameter)
    }
    
    
    func getPointExpire_Api(){
        let parameter : [String : Any] = [
                "ActionType": 166,
                "RoleIDs": loyaltyId
        ]
        self.VM.expirePointsDetailsApi(parameter: parameter)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.VM.voucherListArray.count)
        return self.VM.voucherListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_VoucherTVCell", for: indexPath) as! HYT_VoucherTVCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.voucherNameLbl.text = self.VM.voucherListArray[indexPath.row].productName
        cell.voucherImage.sd_setImage(with: URL(string: self.VM.voucherListArray[indexPath.row].productImage ?? ""), placeholderImage: UIImage(named: "ic_default_img (1)"))
        cell.rangeValueLbl.text = "\(self.VM.voucherListArray[indexPath.row].min_points ?? "0") - \(self.VM.voucherListArray[indexPath.row].max_points ?? "0")"
        cell.voucherDetails = self.VM.voucherListArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_VoucherDetailsVC") as? HYT_VoucherDetailsVC
        vc?.pointExpireDetails = self.VM.pointExpireDetails
        vc?.productDetails = self.VM.voucherListArray[indexPath.row]
        vc?.currentDate = currentDate
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == voucherTableView{
            if indexPath.row == (self.VM.voucherListArray.count - 1){
                if noOfElement == 10{
                    startIndex += 1
                    getVoucherList_Api()
                }else if noOfElement > 10{
                    startIndex += 1
                    getVoucherList_Api()
                }else if noOfElement < 10{
                    print("no need to reload data")
                    return
                }else{
                    print("No data available")
                    return
                }
            }
        }

    }

}
