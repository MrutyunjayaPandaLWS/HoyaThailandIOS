//
//  HYT_MyEarningsVC.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit
import LanguageManager_iOS

class HYT_MyEarningsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FilterProtocolDelegate, InternetCheckDelgate {
    
    func interNetIsON(item: IOS_Internet_Check) {
        myEarningList_Api()
        getPointExpireReportDetails()
    }
    func didTappedResetFilterBtn(item: HYT_FilterVC) {
        fromDate = ""
        toDate = ""
        promotionName = ""
        promotionId = ""
        myEarningList_Api()
    }
    
    func didTappedFilterBtn(item: HYT_FilterVC) {
        fromDate = item.fromDate
        toDate = item.toDate
        promotionName = item.statusName
        promotionId = item.statusId
        myEarningList_Api()
    }
    


    @IBOutlet weak var availablePointsLbl: UILabel!
    @IBOutlet weak var availablePointsTitleLbl: UILabel!
    @IBOutlet weak var expiredPointsLbl: UILabel!
    @IBOutlet weak var expiredPointsTitleLbl: UILabel!
    @IBOutlet weak var redeemPointsTitleLbl: UILabel!
    @IBOutlet weak var redeemedPointsLbl: UILabel!
    @IBOutlet weak var earnedPointTitleLbl: UILabel!
    @IBOutlet weak var earnedPointLbl: UILabel!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var myEarningTableView: UITableView!
    var VM = HYT_MyEarningsVM()
    
    var fromDate = ""
    var toDate = ""
    var promotionName = ""
    var promotionId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        myEarningTableView.delegate = self
        myEarningTableView.dataSource = self
        myEarningTableView.register(UINib(nibName: "HYT_MyEarningsTVCell", bundle: nil), forCellReuseIdentifier: "HYT_MyEarningsTVCell")
        emptyMessage.isHidden = true
        self.myEarningTableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 50,right: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.delegate = self
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            myEarningList_Api()
            getPointExpireReportDetails()
        }
//        myEarningList_Api()
//        getPointExpireReportDetails()
        localization()
    }
    
    @IBAction func didTappedFilterBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_FilterVC") as? HYT_FilterVC
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        vc?.flags = "promotionList"
        vc?.fromDate = fromDate
        vc?.toDate = toDate
        vc?.statusId = promotionId
        vc?.statusName = promotionName
        vc?.tagName =  1
        vc?.delegate = self
        present(vc!, animated: true)
    }

    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    
    func myEarningList_Api(){
        let parameter : [String : Any] = [
            
                "ActionType": 7,
                "ActiveStatus": 1,
                "SalesPersonId": loyaltyId,
                "FromDate": fromDate,
                "ToDate": toDate,
                "ProgramID": promotionId
        ]
        print(parameter,"myEarningList_Api")
        self.VM.myEarningListApi(parameter: parameter)
    }
    
    func getPointExpireReportDetails(){
        let parameter : [String : Any] = [
            "ActionType": 1,
            "LoyaltyId": "\(self.loyaltyId)",
                "FromDate": fromDate,
                "ToDate": toDate
            
        ]
        print(parameter,"point expire report")
        self.VM.pointExpireReportApi(parameter: parameter)
    }
    
//    MARK: - MY EARNINGS TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.myEarningList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_MyEarningsTVCell", for: indexPath) as! HYT_MyEarningsTVCell
        cell.selectionStyle = .none
        if self.VM.myEarningList[indexPath.row].remarks?.contains("Reward Adjustment") == true{
            
//            cell.productStatus.text = "Reward Adjustment"
            cell.pointsView.backgroundColor = primaryColor
        }else if self.VM.myEarningList[indexPath.row].remarks?.contains("Points Credited") == true{
            
            
//            cell.productStatus.text = "Point credited"
            cell.pointsView.backgroundColor = primaryColor
        }else{
//            cell.expireDateView.constant = 0
//            cell.productStatus.text = "Sale Return"
            cell.pointsView.backgroundColor = .red
            
        }
        if self.VM.myEarningList[indexPath.row].remarks?.contains("(") == true{
            var splitValue = self.VM.myEarningList[indexPath.row].remarks?.split(separator: "(")
//            let splitValue2 = splitValue?[1].split(separator: ")")
            cell.productStatus.text = "\(splitValue?[0] ?? "")"//"\(splitValue2?[0].dropFirst(1) ?? "")"
        }else{
            cell.productStatus.text = self.VM.myEarningList[indexPath.row].remarks
        }
            
//            print("behaviour id - ",self.VM.myEarningList[indexPath.row].behaviourId ?? 0)
            
        if self.VM.myEarningList[indexPath.row].behaviourId == 8 || self.VM.myEarningList[indexPath.row].behaviourId == 32{
            cell.expireDateView.constant = 0
            cell.pointsView.backgroundColor = .red
        }else{
            let expDate = self.VM.myEarningList[indexPath.row].pointExpiryDate?.split(separator: " ")
            cell.expiredateLbl.text = "\(expDate?[0] ?? "")"
            cell.expireDateView.constant = 40
            cell.pointsView.backgroundColor = myEarningColor
        }
        
        
        cell.pointsLbl.text = "\(Int(self.VM.myEarningList[indexPath.row].creditedPoint ?? 0))"
        cell.invoiceNumberLbl.text = self.VM.myEarningList[indexPath.row].invoiceNo ?? "-"
        cell.productNameLbl.text = self.VM.myEarningList[indexPath.row].productName ?? "-"
        let date = self.VM.myEarningList[indexPath.row].trxnDate?.split(separator: " ")
        cell.dateLbl.text = String(date?[0] ?? "-")
        cell.promotionNameLbl.text = self.VM.myEarningList[indexPath.row].assessmentName ?? "-"
        return cell
    }
 
    private func localization(){
        titleLbl.text = "myEarnings".localiz()
        earnedPointTitleLbl.text = "Earned Points".localiz()
        redeemPointsTitleLbl.text = "Redeemed Points".localiz()
        expiredPointsTitleLbl.text = "Expired Points".localiz()
        availablePointsTitleLbl.text = "Available Points".localiz()
        emptyMessage.text = "No data found!".localiz()
    }
    
}
