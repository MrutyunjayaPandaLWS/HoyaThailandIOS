//
//  HYT_VoucherDetailsVM.swift
//  Hoya Thailand
//
//  Created by syed on 01/03/23.
//

import Foundation


class HYT_VoucherDetailsVM{
    var requestAPIs = RestAPI_Requests()
    weak var VC: HYT_VoucherDetailsVC?
    
    
    //    MARK: - VOUCHER REDEEMPTION API
        func voucherRedeemptionApi(parameter: JSON){
            self.VC?.startLoading()
            requestAPIs.voucherRedeemption(parameters: parameter){ result, error in
                if error == nil{
                    if result != nil{
                        DispatchQueue.main.async {
                            self.VC?.successMessagePopUp(message: "Your voucher redeemed successfully")
                            self.VC?.dashboardApi()
                            print("exception message - ",result?.exceptionMessage)
                            print("exceptionType - ",result?.exceptionType)
                            print("message - ",result?.message)
                            print("stackTrace -",result?.stackTrace)
                            self.VC?.navigationController?.popViewController(animated: true)
                            self.VC?.stopLoading()
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
                        print("Voucher Redeemption error",error?.localizedDescription)
                    }
                }
            }
            DispatchQueue.main.async {
                self.VC?.stopLoading()
            }
        }
    
    func dashBoardApi(parameter: JSON){
        
        self.VC?.startLoading()
        self.requestAPIs.dashBoardApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    let dashboarMyVehicleDetails = result?.objImageGalleryList ?? ""
                    if dashboarMyVehicleDetails.count == 0{
                    }else{
                    }
                   let dashboardDetails = result?.objCustomerDashboardList ?? []
                    if dashboardDetails.count != 0 {
                                self.VC?.availableBalanceLbl.text = "\(Int(result?.objCustomerDashboardList?[0].totalRedeemed ?? 0))"
                        self.VC?.totalRedeemPoint = Int(result?.objCustomerDashboardList?[0].totalRedeemed ?? 0)
                                UserDefaults.standard.setValue(result?.objCustomerDashboardList?[0].totalRedeemed ?? "", forKey: "TotalPoints")
                                UserDefaults.standard.synchronize()
                                   
                            }
                        let customerFeedbakcJSON = result?.lstCustomerFeedBackJsonApi ?? []
                        if customerFeedbakcJSON.count != 0 {
                            if result?.lstCustomerFeedBackJsonApi?[0].customerStatus ?? 0 != 1{
                                DispatchQueue.main.async{
                                }
                            }else{
                               
                            }
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
                }
            }
        }
    }
}
