//
//  HYT_PointsExpiryReportVC.swift
//  Hoya Thailand
//
//  Created by syed on 14/02/23.
//

import UIKit

class HYT_PointsExpiryReportVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FilterProtocolDelegate {
    func didTappedFilterBtn(item: HYT_FilterVC) {
        fromDate = item.fromDate
        toDate = item.toDate
        getPointExpireReportDetails()
    }
    

    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var lineView3: UIView!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var pointsExpireReportTV: UITableView!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var pointsTitleLbl: UILabel!
    
    var fromDate = ""
    var toDate = ""
    var VM = HYT_PointExpireReportVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        pointsExpireReportTV.delegate = self
        pointsExpireReportTV.dataSource = self
        drawDottedLine(start: CGPoint(x: lineView1.bounds.minX, y: lineView1.bounds.minY), end: CGPoint(x: lineView1.bounds.maxX, y: lineView1.bounds.minY), view: lineView1)
        drawDottedLine(start: CGPoint(x: lineView3.bounds.minX, y: lineView3.bounds.minY), end: CGPoint(x: lineView3.bounds.maxX, y: lineView3.bounds.minY), view: lineView3)
        emptyMessage.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPointExpireReportDetails()
    }
    
    @IBAction func didTappedFilterBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_FilterVC") as? HYT_FilterVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.promotionNameHeight = 0
        vc?.bottomConstraintsValue = 0
        vc?.delegate = self
        present(vc!, animated: true)
    }
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func getPointExpireReportDetails(){
        let parameter : [String : Any] = [
        
            "LoyaltyId": "\(self.loyaltyId)",
                "FromDate": fromDate,
                "ToDate": toDate
            
        ]
        self.VM.pointExpireReportApi(parameter: parameter)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.pointExpireReportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_PointsExpiryReportTVCell", for: indexPath) as! HYT_PointsExpiryReportTVCell
        drawDottedLine(start: CGPoint(x: cell.lineView2.bounds.minX, y: cell.lineView2.bounds.minY), end: CGPoint(x: cell.lineView2.bounds.maxX, y: cell.lineView2.bounds.minY), view: cell.lineView2)
        cell.dateLbl.text = String(self.VM.pointExpireReportList[indexPath.row].jPointsExpiryDate?.prefix(10) ?? "")
        cell.pointLbl.text = "\(self.VM.pointExpireReportList[indexPath.row].pointsGoingtoExpire ?? 0)"
        cell.selectionStyle = .none
        return cell
    }
    

}
