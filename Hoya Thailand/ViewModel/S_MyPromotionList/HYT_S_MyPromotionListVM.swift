//
//  HYT_S_MyPromotionListVM.swift
//  Hoya Thailand
//
//  Created by syed on 28/02/23.
//

import Foundation
import LanguageManager_iOS

class HYT_S_MyPromotionListVM {
    weak var VC : HYT_S_PromotionVC?
    
    var requestAPIs = RestAPI_Requests()
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
                            self.VC?.promotionListTV.reloadData()
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.emptyMessage.isHidden = false
                            self.VC?.emptyMessage.text = "No data found!".localiz()
                            self.VC?.promotionListTV.reloadData()
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
                    print("My promotion list error",error?.localizedDescription)
                }
            }
        }
    }

}
