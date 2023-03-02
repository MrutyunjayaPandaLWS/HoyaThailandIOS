//
//  HYT_PromotionDetailsVM.swift
//  Hoya Thailand
//
//  Created by syed on 28/02/23.
//

import Foundation


class HYT_PromotionDetailsVM{
    weak var VC : HYT_PromotionDetailsVC?
    var requestAPIs = RestAPI_Requests()
    var promotionProductList = [LsrProductDetails]()
    func productListApi(parameter: JSON){
        self.promotionProductList.removeAll()
        self.VC?.startLoading()
        requestAPIs.getPromotionDetailsProductList(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.promotionProductList = result?.lsrProductDetails ?? []
                    DispatchQueue.main.async {
                        if result?.lsrProductDetails?.count != 0{
//                            self.VC?.emptyMessageLbl.isHidden = true
                            self.VC?.productListTableView.reloadData()
                            self.VC?.stopLoading()
                        }else{
//                            self.VC?.emptyMessageLbl.isHidden = false
                            self.VC?.productListTableView.reloadData()
//                            self.VC?.emptyMessageLbl.text = "No data found"
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
