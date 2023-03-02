//
//  HYT_MyRedemptionVM.swift
//  Hoya Thailand
//
//  Created by syed on 27/02/23.
//

import Foundation


class HYT_MyRedemptionVM{
    
    var requestAPIs = RestAPI_Requests()
    weak var VC: HYT_MyRedemptionVC?
    var myRedeemptionList = [ObjCatalogueRedemReqList]()
    func myRedeemptionListApi(parameter: JSON){
        self.myRedeemptionList.removeAll()
        self.VC?.startLoading()
        requestAPIs.myRedeemptionListApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.myRedeemptionList = result?.objCatalogueRedemReqList ?? []
                    DispatchQueue.main.async {
                        if result?.objCatalogueRedemReqList?.count != 0 && result?.objCatalogueRedemReqList != nil {
                            self.VC?.emptyMessageLbl.isHidden = true
                            self.VC?.myRedeemptionTableView.reloadData()
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.emptyMessageLbl.isHidden = false
                            self.VC?.myRedeemptionTableView.reloadData()
                            self.VC?.emptyMessageLbl.text = "No data found"
                            self.VC?.stopLoading()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("My Redeemption error",error?.localizedDescription)
                }
            }
        }
    }
}





