//
//  HYT_MyEarningsVM.swift
//  Hoya Thailand
//
//  Created by syed on 25/02/23.
//

import Foundation
 
class HYT_MyEarningsVM{
    
    var requestAPIs = RestAPI_Requests()
    weak var VC: HYT_MyEarningsVC?
    var myEarningList = [CustomerBasicInfoListJson]()
    
    func myEarningListApi(parameter: JSON){
        self.VC?.startLoading()
        self.myEarningList.removeAll()
        requestAPIs.myEarningListApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.myEarningList = result?.customerBasicInfoListJson ?? []
                    DispatchQueue.main.async {
                        if result?.customerBasicInfoListJson?.count != 0{
                            self.VC?.emptyMessage.isHidden = true
                            self.VC?.myEarningTableView.reloadData()
                            self.VC?.stopLoading()
                            
                        }else{
                            self.VC?.emptyMessage.isHidden = false
                            self.VC?.emptyMessage.text = "No data found"
                            self.VC?.myEarningTableView.reloadData()
                            self.VC?.stopLoading()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("My Earning error",error?.localizedDescription)
                }
            }  
        }
    }

}

