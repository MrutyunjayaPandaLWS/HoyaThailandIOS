//
//  HYT_MyRedemptionVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit

class HYT_MyRedemptionVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FilterProtocolDelegate,myRedeemptionDelegate {
    func downloadVoucher(item: HYT_MyRedemptionTVCell) {
        
    }
    
    func didTappedFilterBtn(item: HYT_FilterVC) {
        fromDate = item.fromDate
        toDate = item.toDate
        statusId = "\(item.statusId)"
        myRedeemptionList_Api()
    }
    

    @IBOutlet weak var emptyMessageLbl: UILabel!
    @IBOutlet weak var myRedeemptionTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var VM = HYT_MyRedemptionVM()
    var fromDate = ""
    var toDate = ""
    var statusId = ""
    var startIndex = 1
    var noOfElement = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        myRedeemptionTableView.delegate = self
        myRedeemptionTableView.dataSource = self
        emptyMessageLbl.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myRedeemptionList_Api()
    }
    
    @IBAction func didTappedFilterBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_FilterVC") as? HYT_FilterVC
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        vc?.delegate = self
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
//  MARK: - MR REDEEMPTION LIST API
    func myRedeemptionList_Api(){
        let parameter : [String : Any] = [
                "ActionType": 52,
                "ActorId": self.userId,
                "StartIndex": startIndex,
                "NoOfRows": "10",
                "CustomerTypeID": self.customerTypeID,
                "ObjCatalogueDetails": [
                    "JFromDate": fromDate,
                    "RedemptionTypeId": "-1",
                    "SelectedStatus": statusId,
                    "JToDate": toDate
                ]
        ]
        
        self.VM.myRedeemptionListApi(parameter: parameter)
    }
    
//    MARK: - MY REDEMPTION TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.myRedeemptionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_MyRedemptionTVCell", for: indexPath) as! HYT_MyRedemptionTVCell
        cell.selectionStyle = .none
        var myRedeemptionData = self.VM.myRedeemptionList[indexPath.row]
        if myRedeemptionData.status == 0 {
            cell.downloadVoucherViewHeight.constant = 60
            cell.statusLbl.text = "Approved"
            cell.statusLbl.textColor = approvedTextColor
            cell.statusLbl.backgroundColor = approvedBgColor
            cell.downloadVoucher = myRedeemptionData.productImage ?? ""
        }else{
            cell.downloadVoucherViewHeight.constant = 0
            cell.statusLbl.text = "Cancel"
            cell.statusLbl.textColor = cancelTextColor
            cell.statusLbl.backgroundColor = cancelBgColor
        }
        cell.pointsLbl.text = "\(myRedeemptionData.redeemedPoints ?? 0)"
        cell.dateLbl.text = String(myRedeemptionData.jRedemptionDate?.prefix(10) ?? "")
        cell.voucherNameLbl.text = myRedeemptionData.productName
        cell.delegate = self
        return cell
    }
    
//    Height = 60
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == myRedeemptionTableView{
            if indexPath.row != (self.VM.myRedeemptionList.count - 1){
                if noOfElement == 10{
                    startIndex += 1
                    myRedeemptionList_Api()
                }else if noOfElement > 10{
                    startIndex += 1
                    myRedeemptionList_Api()
                }else if noOfElement < 10{
                    print("no need to reload")
                    return
                }else{
                    print("no more data available")
                    return
                }
            }
        }
    }
    
}
