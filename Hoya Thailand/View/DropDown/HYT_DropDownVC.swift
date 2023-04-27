//
//  HYT_DropDownVC.swift
//  Hoya Thailand
//
//  Created by syed on 21/02/23.
//

import UIKit

protocol DropdownDelegate{
    func didTappedPromotionName(item: HYT_DropDownVC)
    func didTappedGenderBtn(item: HYT_DropDownVC)
    func didTappedAccountType(item: HYT_DropDownVC)
    func didTappedRoleBtn(item: HYT_DropDownVC)
    func didTappedSalesRepresentative(item: HYT_DropDownVC)
}

protocol FilterStatusDelegate{
    func didTappedFilterStatus(item: HYT_DropDownVC)
}

class HYT_DropDownVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var dropdownTableView: UITableView!
    var delegate: DropdownDelegate?
    var delegate1: FilterStatusDelegate?
    var rowNumber = 0
    var flags = ""
    var progrmaId = 0
    var genderList = ["Male","Female","Don't want to show"]
    var promotionNameList = ["promotion-A","promotion-B","promotion-C","promotion-D","promotion-E"]
    var accountTypeList = ["Store owner","Individual"]
    var roleList = ["Frontliner"]
    var salesRepresentativeList = ["SalesRepresentative-1","SalesRepresentative-2","SalesRepresentative-3"]
    var myRedeemptionStatus : [myredeemptionStatusModel] = [myredeemptionStatusModel(statusName: "Approved", statusID: 0),myredeemptionStatusModel(statusName: "Cancelled", statusID: 1)]
    var genderName = ""
    var promotionName = ""
    var accountType = ""
    var roleName = ""
    var roleId = 0
    var salesRepresentativeName = ""
    var statusName: String = ""
    var statusId:Int = 0
    var locationId = ""
    var VM = HYT_DropdownVM()
    var salesRepId = 0
    var accountTypeId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.VM.VC = self
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch flags{
        case "gender":
            rowNumber = genderList.count
            heightOfTableView.constant = CGFloat(45 * rowNumber)
            dropdownTableView.reloadData()
        case "promotionName":
            rowNumber = promotionNameList.count
            heightOfTableView.constant = CGFloat(45 * rowNumber)
            dropdownTableView.reloadData()
        case "accountType":
            rowNumber = accountTypeList.count
            heightOfTableView.constant = CGFloat(45 * rowNumber)
            dropdownTableView.reloadData()
        case "role":
            roleListApi()
        case "sales":
            salesRepresentativeAPI()
        case "queryStatus":
            queryStatusApi()
        case "promotionList":
            getPromotionList_Api()
        case "myRedeemption":
            rowNumber = myRedeemptionStatus.count
        case "productList":
            getProductList_Api()
            
        default:
            print("invalid flags")
        }
    }
    

    
    func roleListApi(){
        let parameter : [String : Any] = [
                "ActionType": 33,
                "RoleIDs": "HOYA"
        ]
        self.VM.roleListinApi(parameter: parameter)
    }
    
    func getPromotionList_Api(){
        let parameter : [String : Any] = [
                "ActionType": 6,
                "CustomerId": self.userId,
                "Domain": "HOYA"
        ]
        
        self.VM.prommtionsListApi(parameter: parameter)
    }
    
    func salesRepresentativeAPI(){
        let parameter : [String : Any] = [
            "ActionType": 31,
            "Actorid": locationId
        ]
        self.VM.salesRepresentativeApi(parameter: parameter)
    }

    func queryStatusApi(){
        let parameter : [String : Any] = [
                "ActionType": "150"
        ]
        self.VM.queryStatusListing(parameter: parameter)
    }
    
    func getProductList_Api(){
        let parameter : [String : Any] = [
                "ActorId":userId,
                 "SearchText": "",
                "LoyaltyProgramId":progrmaId ?? 0,
                "ProductDetails":[
                    "ActionType": 20
                ]
        ]
        
        self.VM.productListApi(parameter: parameter)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_DropDownTVCell", for: indexPath) as! HYT_DropDownTVCell
        cell.selectionStyle = .none
        switch flags{
        case "gender":
            cell.nameLbl.text = genderList[indexPath.row]
        case "promotionName":
            cell.nameLbl.text = promotionNameList[indexPath.row]
        case "accountType":
            cell.nameLbl.text = accountTypeList[indexPath.row]
        case "role":
            cell.nameLbl.text = self.VM.roleListArray[indexPath.row].attributeValue
        case "sales":
            cell.nameLbl.text = self.VM.salesRepresentativeList[indexPath.row].attributeValue
        case "queryStatus":
            cell.nameLbl.text = self.VM.queryStatusList[indexPath.row].attributeValue
        case "promotionList":
            cell.nameLbl.text = self.VM.promotionList[indexPath.row].programName
        case "myRedeemption":
            cell.nameLbl.text = myRedeemptionStatus[indexPath.row].statusName
        case "productList":
            cell.nameLbl.text = self.VM.promotionProductList[indexPath.row].productName
        default:
            print("invalid code")
        }
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch flags{
        case "gender":
            genderName = genderList[indexPath.row]
            delegate?.didTappedGenderBtn(item: self)
            
        case "promotionName":
            promotionName = promotionNameList[indexPath.row]
            delegate?.didTappedPromotionName(item: self)
        case "accountType":
            accountType = accountTypeList[indexPath.row]
            delegate?.didTappedAccountType(item: self)
        case "role":
            roleId = self.VM.roleListArray[indexPath.row].attributeId ?? 0
            roleName = self.VM.roleListArray[indexPath.row].attributeValue ?? "Select role"
            delegate?.didTappedRoleBtn(item: self)
        case "sales":
            salesRepresentativeName = self.VM.salesRepresentativeList[indexPath.row].attributeValue ?? "Select sales representative"
            salesRepId = self.VM.salesRepresentativeList[indexPath.row].attributeId ?? 0
            delegate?.didTappedSalesRepresentative(item: self)
            
        case "queryStatus":
            statusName = self.VM.queryStatusList[indexPath.row].attributeValue ?? ""
            statusId = self.VM.queryStatusList[indexPath.row].attributeId ?? 0
            delegate1?.didTappedFilterStatus(item: self)
        case "promotionList":
            statusName = self.VM.promotionList[indexPath.row].programName ?? ""
            statusId = self.VM.promotionList[indexPath.row].programId ?? 0
            delegate?.didTappedPromotionName(item: self)
            delegate1?.didTappedFilterStatus(item: self)
        case "myRedeemption":
            statusName = self.myRedeemptionStatus[indexPath.row].statusName ?? ""
            statusId = self.myRedeemptionStatus[indexPath.row].statusID ?? 0
            delegate1?.didTappedFilterStatus(item: self)
        case "productList":
            statusName = self.VM.promotionProductList[indexPath.row].productName ?? ""
            statusId = self.VM.promotionProductList[indexPath.row].productId ?? 0
            delegate1?.didTappedFilterStatus(item: self)
        default:
            print("invalid flags")
        }
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view{
                    dismiss(animated: true)
        }
    }

}

struct myredeemptionStatusModel{
    let statusName : String
    let statusID : Int
    
}
