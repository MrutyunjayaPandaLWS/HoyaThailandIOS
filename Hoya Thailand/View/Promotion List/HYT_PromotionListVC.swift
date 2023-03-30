//
//  HYT_PromotionListVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import LanguageManager_iOS

class HYT_PromotionListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, PromotionListDelegate {
    
    func didTappedPromotionDetails(item: HYT_PromotionListTVCell) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_PromotionDetailsVC") as? HYT_PromotionDetailsVC
        vc?.promotionDetailsData = item.promotionData
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func didTappedPromotionClaim(item: HYT_PromotionListTVCell) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_ClaimDetailsVC") as? HYT_ClaimDetailsVC
        vc?.promotionData = item.promotionData
        navigationController?.pushViewController(vc!, animated: true)
        
    }

    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var promotionListTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var VM = HYT_PromotionListVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        promotionListTableView.delegate = self
        promotionListTableView.dataSource = self
        emptyMessage.isHidden = true
        localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPromotionList_Api()
    }

    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func getPromotionList_Api(){
        let parameter : [String : Any] = [
                   "ActionType": 6,
                   "CustomerId": userId,
                   "Domain": "HOYA"
        ]
        
        self.VM.prommtionsListApi(parameter: parameter)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.promotionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_PromotionListTVCell", for: indexPath) as! HYT_PromotionListTVCell
        cell.selectionStyle = .none
        cell.promotionDetailsLbl.text = self.VM.promotionList[indexPath.row].programDesc
        cell.promotionNameLbl.text = self.VM.promotionList[indexPath.row].programName
        cell.validityDateLbl.text = "\("validUntli".localiz()) : \(self.VM.promotionList[indexPath.row].jEndDate?.prefix(10) ?? "")"
        cell.promotionData = self.VM.promotionList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    private func localization(){
        titleLbl.text = "promotionList".localiz()
        
    }

}
