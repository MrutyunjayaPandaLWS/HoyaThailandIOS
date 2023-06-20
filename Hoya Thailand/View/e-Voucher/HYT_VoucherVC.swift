//
//  HYT_VoucherVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import Toast_Swift
import SDWebImage
import LanguageManager_iOS

class HYT_VoucherVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,RedeemVoucherDelegate, pointsDelegate, SuccessMessageDelegate {
    func goToLoginPage(item: HYT_SuccessMessageVC) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func selectPointsDidTap(_ VC: RedeemQuantity_VC) {
                self.selectedPoints = VC.selectedpoints
                self.productcodeselected = VC.productCodefromPrevious
                print(VC.selectedpoints)
                print(VC.productCodefromPrevious)
                print(productcodeselected,"sdkjdn")
        let index = IndexPath(item: VC.tappedIndex, section: 0)
        self.VM.voucherListArray[VC.tappedIndex].selectedAmount = VC.selectedpoints
        self.voucherTableView.reloadRows(at: [index], with: UITableView.RowAnimation.none)
    }
    
    func didTappedSelectAmountbtn(item: HYT_VoucherTVCell) {
        guard let tappedIndexPath = self.voucherTableView.indexPath(for: item) else {return}
        DispatchQueue.main.async{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RedeemQuantity_VC") as? RedeemQuantity_VC
            vc!.productCodefromPrevious = self.VM.voucherListArray[tappedIndexPath.row].productCode ?? ""
            vc!.delegate = self
            vc?.voucherListArray = self.VM.voucherListArray
            vc!.tappedIndex = tappedIndexPath.row
            vc!.modalPresentationStyle = .overCurrentContext
            vc!.modalTransitionStyle = .crossDissolve
            self.present(vc!, animated: true, completion: nil)
        
        }
    }
    
    
    func didTappedRedeemVoucherBtn(item: HYT_VoucherTVCell) {
        if item.voucherDetails?.product_type == 1{
            let EnterAmount = Int(item.amountTF.text ?? "0")
            if item.amountTF.text?.count == 0{
                self.view.makeToast("Enter amount", duration: 2.0, position: .center)
            }else if Int(item.voucherDetails?.min_points ?? "0") ?? 0 <= Int(item.amountTF.text ?? "") ?? 0 && Int(item.voucherDetails?.max_points ?? "0") ?? 0 >= Int(item.amountTF.text ?? "") ?? 0{
                var redeemValue = Int(item.amountTF.text ?? "0")
                if redeemValue == 0{
                    self.view.makeToast("Redeem value shouldn't be 0", duration: 2.0, position: .center)
                    item.amountTF.text = ""
                }else if totalRedeemPoint < EnterAmount!{
                    self.view.makeToast("insufficient Redeemable Balance", duration: 2.0, position: .center)
                    item.amountTF.text = ""
                }else{
                    redeemVoucher(countryID: item.voucherDetails?.countryID ?? 0, catalogueID: item.voucherDetails?.catalogueId ?? 0, amount: item.amountTF.text ?? "0", productCode: item.voucherDetails?.productCode ?? "0", productImage: item.voucherDetails?.productImage ?? "", productName: item.voucherDetails?.productName ?? "", currentDate: currentDate, venderID: item.voucherDetails?.vendorId ?? 0, redemptionId: item.voucherDetails?.redemptionId ?? 0)
                    item.amountTF.text = ""
                }
            }else{
                self.view.makeToast("Enter amount between min & max range", duration: 2.0, position: .center)
                item.amountTF.text = ""
            }
        }else{
            if item.selectAmountLbl.text == "Select Amount"{
                self.view.makeToast("Please Select amount", duration: 2.0, position: .center)
            }else{
                var redeemValue = Int(item.selectAmountLbl.text ?? "0")
                if redeemValue == 0{
                    self.view.makeToast("Redeem value shouldn't be 0", duration: 2.0, position: .center)
                    item.selectAmountLbl.text = "Select Amount"
                }else if totalRedeemPoint < redeemValue!{
                    self.view.makeToast("insufficient Redeemable Balance", duration: 2.0, position: .center)
                    item.amountTF.text = ""
                }else{
                    redeemVoucher(countryID: item.voucherDetails?.countryID ?? 0, catalogueID: item.voucherDetails?.catalogueId ?? 0, amount: item.selectAmountLbl.text ?? "0", productCode: item.voucherDetails?.productCode ?? "0", productImage: item.voucherDetails?.productImage ?? "", productName: item.voucherDetails?.productName ?? "", currentDate: currentDate, venderID: item.voucherDetails?.vendorId ?? 0, redemptionId: item.voucherDetails?.redemptionId ?? 0)
                }
            }
        }
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
                      "ReceiverEmail": "lohith.loyltwo3ks@gmail.com",
                      "ReceiverMobile": customerMobileNumber ?? "",
                      "SourceMode": 4
        ]
        print(parameter)
        self.VM.voucherRedeemptionApi(parameter: parameter)
    }

    @IBOutlet weak var pointsView: UIView!
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
    var tomorrowDate = ""
    var startIndex = 1
    var noOfElement = 0
    var totalRedeemPoint = 0
    var productcodeselected = ""
    var selectedPoints = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        emptyMessageLbl.isHidden = true
        voucherTableView.delegate = self
        voucherTableView.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getVoucherList_Api()
        getPointExpire_Api()
        currentdate()
        localization()
        dashboardApi()
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
    
    func tomorrowdate(){
        var tomorrow: Date {
            return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        let dateOutDefault = dateFormatter.string(from: tomorrow as Date)
        print("tomorrow date", dateOutDefault)
        expireDateLbl.text = "will Expire on : \( dateOutDefault)"
        self.tomorrowDate = "\(dateOutDefault)"
        
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
        print(parameter,"getVoucherList_Api")
        self.VM.voucherListApi(parameter: parameter)
    }
    
    
    func getPointExpire_Api(){
        let parameter : [String : Any] = [
                "ActionType": 166,
                "RoleIDs": loyaltyId
        ]
        print(parameter,"getpoint expire api")
        self.VM.expirePointsDetailsApi(parameter: parameter)
    }
    
    func dashboardApi(){
        let parameter : [String : Any] = [
                "ActorId": userId
        ]
        print(parameter,"dashboard api")
        self.VM.dashBoardApi(parameter: parameter)
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
        cell.vouchersdata.append(self.VM.voucherListArray[indexPath.row])
        cell.voucherDetails = self.VM.voucherListArray[indexPath.row]
        if self.VM.voucherListArray[indexPath.row].product_type == 1{
            cell.rangeValueLbl.isHidden = false
            cell.rangeLbl.isHidden = false
            cell.dropdownIconView.isHidden = true
            cell.rangeValueLbl.text = "\(self.VM.voucherListArray[indexPath.row].min_points ?? "0") - \(self.VM.voucherListArray[indexPath.row].max_points ?? "0")"
            cell.enterAmountView.isHidden = false
        }else{
            cell.rangeValueLbl.isHidden = true
            cell.rangeLbl.isHidden = true
            cell.dropdownIconView.isHidden = false
            cell.enterAmountView.isHidden = true
            if self.VM.voucherListArray[indexPath.row].selectedAmount == 0{
                cell.selectAmountLbl.text = "Select Amount"
            }else{
                cell.selectAmountLbl.text = "\(self.VM.voucherListArray[indexPath.row].selectedAmount)"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_VoucherDetailsVC") as? HYT_VoucherDetailsVC
        vc?.pointExpireDetails = self.VM.pointExpireDetails
        vc?.productDetails = self.VM.voucherListArray[indexPath.row]
        vc?.currentDate = currentDate
        vc?.tomorrowDate = self.tomorrowDate
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
    
    func localization(){
        titleLbl.text = "e_voucher".localiz()
        availableBalanceLbl.text = "availableBal".localiz()
        emptyMessageLbl.text = "No data found!".localiz()
        
    }
    
    func successPopup(){

    }

}
