//
//  HYT_PromotionListVM.swift
//  Hoya Thailand
//
//  Created by syed on 27/02/23.
//

import Foundation


class HYT_PromotionListVM{
    
    var requestAPIs = RestAPI_Requests()
    weak var VC: HYT_PromotionListVC?
    var promotionList = [LtyPrgBaseDetails]()
    func prommtionsListApi(parameter: JSON){
        self.promotionList.removeAll()
        self.VC?.startLoading()
        requestAPIs.getPromotionListApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.promotionList = result?.ltyPrgBaseDetails ?? []
                    DispatchQueue.main.async {
                        if result?.ltyPrgBaseDetails?.count != 0 && result?.ltyPrgBaseDetails != nil{
                            self.VC?.emptyMessage.isHidden = true
                            self.VC?.promotionListTableView.reloadData()
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.emptyMessage.isHidden = false
                            self.VC?.emptyMessage.text = "No data found"
                            self.VC?.promotionListTableView.reloadData()
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
