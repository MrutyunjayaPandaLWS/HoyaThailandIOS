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
//        self.myRedeemptionList.removeAll()
        self.VC?.startLoading()
        requestAPIs.myRedeemptionListApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    let myRedeemptionListArray = result?.objCatalogueRedemReqList ?? []
                    if myRedeemptionListArray.isEmpty == false || myRedeemptionListArray.count != 0 {
                        self.myRedeemptionList = myRedeemptionListArray
                        DispatchQueue.main.async {
                            self.VC?.noOfElement = self.myRedeemptionList.count
                            if self.myRedeemptionList.count != 0{
                                self.VC?.emptyMessageLbl.isHidden = true
                                self.VC?.myRedeemptionTableView.reloadData()
                                self.VC?.stopLoading()
                            }else{
                                self.VC?.emptyMessageLbl.isHidden = false
                                self.VC?.noOfElement = 0
                                self.VC?.startIndex = 1
                                self.VC?.myRedeemptionTableView.reloadData()
                                self.VC?.emptyMessageLbl.text = "No data found"
                                self.VC?.stopLoading()
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.VC?.emptyMessageLbl.isHidden = false
                            self.VC?.emptyMessageLbl.text = "No data found"
                            self.VC?.stopLoading()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.emptyMessageLbl.isHidden = false
                        self.VC?.emptyMessageLbl.text = "No data found"
                        self.VC?.stopLoading()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    self.VC?.emptyMessageLbl.isHidden = false
                    self.VC?.emptyMessageLbl.text = "No data found"
                    print("My Redeemption error",error?.localizedDescription)
                }
            }
        }
    }
}





