//
//  HYT_S_PromotionDetailsVC.swift
//  Hoya Thailand
//
//  Created by syed on 23/02/23.
//

import UIKit
import LanguageManager_iOS


class HYT_S_PromotionDetailsVC: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var vcTitleLbl: UILabel!
    @IBOutlet weak var pointsTitleLbl: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var promotionDate: UILabel!
    @IBOutlet weak var promotionsDateLbl: UILabel!
    @IBOutlet weak var productListTV: UITableView!
    @IBOutlet weak var lineView4: UIView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var promotionDetails: UILabel!
    @IBOutlet weak var promotionNameLbl: UILabel!
    var promotionDetails1: LtyPrgBaseDetails?
    var VM = HYT_S_PromotionDetailsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        productListTV.delegate = self
        productListTV.dataSource = self
        
        drawDottedLine(start: CGPoint(x: lineView1.bounds.minX, y: lineView1.bounds.minY), end: CGPoint(x: lineView1.bounds.maxX + 10, y: lineView1.bounds.minY), view: lineView1)
        drawDottedLine(start: CGPoint(x: lineView2.bounds.minX, y: lineView2.bounds.minY), end: CGPoint(x: lineView2.bounds.maxX + 10, y: lineView2.bounds.minY), view: lineView2)
        localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        promotionDate.text = String(promotionDetails1?.jEndDate?.prefix(10) ?? "")
        promotionNameLbl.text = promotionDetails1?.programName
        promotionDetails.text = promotionDetails1?.programDesc
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            getProductList_Api()
        }
    }

    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func getProductList_Api(){
        let parameter : [String : Any] = [
                "ActorId":userId,
                 "SearchText": "",
                "LoyaltyProgramId":promotionDetails1?.programId ?? 0,
                "ProductDetails":[
                    "ActionType": 20
                ]
        ]
        
        self.VM.productListApi(parameter: parameter)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = CGFloat(30*self.VM.promotionProductList.count)
        return self.VM.promotionProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_S_PromotionDetailsTVCell", for: indexPath) as! HYT_S_PromotionDetailsTVCell
        let productData = self.VM.promotionProductList[indexPath.row]
        cell.selectionStyle = .none
        cell.pointsLbl.text = "\(productData.points ?? 0)"
        cell.productNameLbl.text = productData.productName
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 30
//    }
    
    private func localization(){
//        productTitleLbl.text = "Lens Design".localiz()
//        pointsTitleLbl.text = "points".localiz()
//        promotionsDateLbl.text = "promotionValid".localiz()
        vcTitleLbl.text = "promotionDetails".localiz()
    }
}
