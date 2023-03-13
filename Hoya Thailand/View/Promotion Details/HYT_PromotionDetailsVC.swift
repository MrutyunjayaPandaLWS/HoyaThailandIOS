//
//  HYT_PromotionDetailsVC.swift
//  Hoya Thailand
//
//  Created by syed on 14/02/23.
//

import UIKit
import WebKit
import LanguageManager_iOS

class HYT_PromotionDetailsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var lineView4: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var pointsTitle: UILabel!
    @IBOutlet weak var productNameTitle: UILabel!
    @IBOutlet weak var promotionDetails: UILabel!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var BenefitdescriptionLbl: UILabel!
    @IBOutlet weak var getBenefitLbl: UILabel!
    @IBOutlet weak var claimBtn: UIButton!
    @IBOutlet weak var promotionDate: UILabel!
    @IBOutlet weak var promotionValidDateLbl: UILabel!
    
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    var promotionDetailsData : LtyPrgBaseDetails?
    var VM = HYT_PromotionDetailsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        productListTableView.delegate = self
        productListTableView.dataSource = self
        
        drawDottedLine(start: CGPoint(x: lineView1.bounds.minX, y: lineView1.bounds.minY), end: CGPoint(x: lineView1.bounds.maxX + 10, y: lineView1.bounds.minY), view: lineView1)
        drawDottedLine(start: CGPoint(x: lineView2.bounds.minX, y: lineView2.bounds.minY), end: CGPoint(x: lineView2.bounds.maxX + 10, y: lineView2.bounds.minY), view: lineView2)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        promotionDate.text = String(promotionDetailsData?.jEndDate?.prefix(10) ?? "")
        userName.text = promotionDetailsData?.programName
        promotionDetails.text = promotionDetailsData?.programDesc
        getProductList_Api()
    }
    
    @IBAction func didTappedClaimBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_ClaimDetailsVC") as? HYT_ClaimDetailsVC
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func getProductList_Api(){
        let parameter : [String : Any] = [
                "ActorId":userId,
                 "SearchText": "",
                "LoyaltyProgramId":promotionDetailsData?.programId ?? 0,
                "ProductDetails":[
                    "ActionType": 20
                ]
        ]
        
        self.VM.productListApi(parameter: parameter)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowNumber = self.VM.promotionProductList.count
        tableViewHeight.constant = CGFloat(30*rowNumber)
        return rowNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_ProductListTVCell", for: indexPath) as! HYT_ProductListTVCell
        let productData = self.VM.promotionProductList[indexPath.row]
        cell.selectionStyle = .none
        cell.pointsLbl.text = "\(productData.points ?? 0)"
        cell.productNameLbl.text = productData.productName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }

    private func localization(){
        
    }
    
    
}
