//
//  HYT_QueryListVM.swift
//  Hoya Thailand
//
//  Created by syed on 27/02/23.
//

import Foundation
class HYT_QueryListVM{
    
    weak var VC: HYT_QueryVC?
    
    var requestAPIs = RestAPI_Requests()
    var queryList = [ObjCustomerAllQueryJsonList]()
    func getQueryList(parameter: JSON){
        self.queryList.removeAll()
        self.VC?.startLoading()
        requestAPIs.getQuerryListApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.queryList = result?.objCustomerAllQueryJsonList ?? []
                    DispatchQueue.main.async {
                        if result?.objCustomerAllQueryJsonList?.count != 0{
                            self.VC?.emptyMessage.isHidden = true
                            self.VC?.queryTableView.reloadData()
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.emptyMessage.isHidden = false
                            self.VC?.queryTableView.reloadData()
                            self.VC?.emptyMessage.text = "No query found"
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
                    print("Query List error",error?.localizedDescription)
                }
            }
        }
    }
}
