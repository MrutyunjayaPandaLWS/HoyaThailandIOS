//
//  HYT_MyEarningsVC.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit

class HYT_MyEarningsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FilterProtocolDelegate {
    func didTappedFilterBtn(item: HYT_FilterVC) {
        fromDate = item.fromDate
        toDate = item.toDate
        promotionName = item.statusName
        promotionId = "\(item.statusId)"
        myEarningList_Api()
    }
    


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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myEarningList_Api()
    }
    
    @IBAction func didTappedFilterBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_FilterVC") as? HYT_FilterVC
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        vc?.flags = "promotionList"
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
        self.VM.myEarningListApi(parameter: parameter)
    }
    
//    MARK: - MY EARNINGS TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.myEarningList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_MyEarningsTVCell", for: indexPath) as! HYT_MyEarningsTVCell
        cell.selectionStyle = .none
        if self.VM.myEarningList[indexPath.row].salesReturn == 0 {
            cell.expireDateView.constant = 40
            cell.productStatus.text = "Point Credit"
            cell.pointsView.backgroundColor = primaryColor
        }else{
            cell.expireDateView.constant = 0
            cell.productStatus.text = "Sale Return"
            cell.pointsView.backgroundColor = .red
            
        }
        
        cell.pointsLbl.text = "\(self.VM.myEarningList[indexPath.row].creditedPoint ?? 0)"
        cell.invoiceNumberLbl.text = self.VM.myEarningList[indexPath.row].invoiceNo
        cell.productNameLbl.text = self.VM.myEarningList[indexPath.row].productName
        cell.dateLbl.text = String(self.VM.myEarningList[indexPath.row].trxnDate?.dropLast(9) ?? "")
        cell.promotionNameLbl.text = self.VM.myEarningList[indexPath.row].assessmentName
        return cell
    }
    
}
