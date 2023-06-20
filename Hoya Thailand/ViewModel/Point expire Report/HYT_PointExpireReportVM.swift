//
//  HYT_PointExpireReportVM.swift
//  Hoya Thailand
//
//  Created by syed on 27/02/23.
//

import Foundation
import LanguageManager_iOS

class HYT_PointExpireReportVM{
    weak var VC: HYT_PointsExpiryReportVC?
    var requestAPIs = RestAPI_Requests()
    var pointExpireReportList = [LstPointsExpiryDetails]()
    var totalPointExpire: Int = 0
    func pointExpireReportApi(parameter: JSON){
        self.VC?.startLoading()
        pointExpireReportList.removeAll()
        requestAPIs.getPonintExpireReport(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.pointExpireReportList = result?.lstPointsExpiryDetails ?? []
                    DispatchQueue.main.async {
                        if result?.lstPointsExpiryDetails?.count != 0{
                            self.VC?.emptyMessage.isHidden = true
                            self.VC?.pointsLbl.isHidden = false
                            self.VC?.pointsTitleLbl.isHidden = false
                            self.VC?.pointLbl.isHidden = false
                            self.VC?.dateLbl.isHidden = false
                            self.VC?.lineView1.isHidden = false
                            self.VC?.lineView3.isHidden = false
                            self.VC?.pointsExpireReportTV.reloadData()
                            for list in self.pointExpireReportList {
                                self.totalPointExpire += list.pointsGoingtoExpire ?? 0
                            }
                            self.VC?.pointsLbl.text = "\(self.totalPointExpire)"
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.emptyMessage.isHidden = false
                            self.VC?.emptyMessage.text = "No data found!".localiz()
                            self.VC?.pointsLbl.isHidden = true
                            self.VC?.pointsTitleLbl.isHidden = true
                            self.VC?.pointLbl.isHidden = true
                            self.VC?.dateLbl.isHidden = true
                            self.VC?.lineView1.isHidden = true
                            self.VC?.lineView3.isHidden = true
                            self.totalPointExpire = 0
                            self.VC?.pointsExpireReportTV.reloadData()
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
