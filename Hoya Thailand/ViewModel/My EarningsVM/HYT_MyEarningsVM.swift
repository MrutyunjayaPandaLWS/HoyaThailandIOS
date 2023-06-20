//
//  HYT_MyEarningsVM.swift
//  Hoya Thailand
//
//  Created by syed on 25/02/23.
//

import Foundation
import LanguageManager_iOS
 
class HYT_MyEarningsVM{
    
    var requestAPIs = RestAPI_Requests()
    weak var VC: HYT_MyEarningsVC?
    var myEarningList = [CustomerBasicInfoListJson]()
    var pointExpireReportList = [LstPointsExpiryDetails]()
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
                            self.VC?.emptyMessage.text = "No data found!".localiz()
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
        DispatchQueue.main.async {
            self.VC?.stopLoading()
        }
    }

    

    func pointExpireReportApi(parameter: JSON){
        self.VC?.startLoading()
        pointExpireReportList.removeAll()
        requestAPIs.getPonintExpireReport(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.pointExpireReportList = result?.lstPointsExpiryDetails ?? []
                    DispatchQueue.main.async {
                        if result?.lstPointsExpiryDetails?.count != 0{
                            self.VC?.earnedPointLbl.text = "\(result?.sumOfEarnedPoints ?? 0)"
                            self.VC?.redeemedPointsLbl.text = "\(result?.sumOfRedeemedPoints ?? 0)"
                            self.VC?.expiredPointsLbl.text = "\(result?.sumOfExpiredPoints ?? 0)"
                            self.VC?.availablePointsLbl.text = "\(result?.sumOfAvailablePoints ?? 0)"
                            self.VC?.stopLoading()
                        }else{
                            
                            
                        
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
                    print("Point Expire Report error",error?.localizedDescription)
                }
            }
        }
    }
    
}

