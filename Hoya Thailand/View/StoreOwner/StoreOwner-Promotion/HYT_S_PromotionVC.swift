//
//  HYT_S_PromotionVC.swift
//  Hoya Thailand
//
//  Created by syed on 23/02/23.
//

import UIKit

class HYT_S_PromotionVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, S_PromotionListDelegate{
    
    func didTappedPromotionDetails(item: HYT_S_PromotionTVCell) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_S_PromotionDetailsVC") as? HYT_S_PromotionDetailsVC
        vc?.promotionDetails1 = item.promotionData
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var promotionListTV: UITableView!
    @IBOutlet weak var vcTitleLbl: UILabel!
    var VM = HYT_S_MyPromotionListVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        promotionListTV.delegate = self
        promotionListTV.dataSource = self
        emptyMessage.isHidden = true
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
                "ActionType": 1,
                "CustomerId": 46,
                "Domain": "HOYA"
        ]
        self.VM.prommtionsListApi(parameter: parameter)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.promotionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_S_PromotionTVCell", for: indexPath) as! HYT_S_PromotionTVCell
        cell.selectionStyle = .none
        cell.promotionDetailsLbl.text = self.VM.promotionList[indexPath.row].programDesc
        cell.promotionsNameLbl.text = self.VM.promotionList[indexPath.row].programName
        cell.validityDateLbl.text = "Validity until : \(self.VM.promotionList[indexPath.row].jEndDate?.dropLast(9) ?? "")"
        cell.promotionData = self.VM.promotionList[indexPath.row]
        cell.delegate = self
        return cell
    }

}
