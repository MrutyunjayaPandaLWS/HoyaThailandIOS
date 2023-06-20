//
//  HYT_VoucherDetailsVM.swift
//  Hoya Thailand
//
//  Created by syed on 01/03/23.
//

import Foundation
import LanguageManager_iOS

class HYT_VoucherDetailsVM: SuccessMessageDelegate{
    func goToLoginPage(item: HYT_SuccessMessageVC) {
        self.VC?.navigationController?.popToRootViewController(animated: true)
    }
    
    var requestAPIs = RestAPI_Requests()
    weak var VC: HYT_VoucherDetailsVC?
    
    
    //    MARK: - VOUCHER REDEEMPTION API
        func voucherRedeemptionApi(parameter: JSON){
            self.VC?.startLoading()
            requestAPIs.voucherRedeemption(parameters: parameter){ result, error in
                if error == nil{
                    if result != nil{
                        let message = result?.returnMessage?.split(separator: "-")
                        let message1 = message?[1].split(separator: "-")
                        print(message1?[0] ?? "")
                        if  Int(message1?[0] ?? "0")! > 0{
                            DispatchQueue.main.async {
                                //                            self.VC?.successMessagePopUp(message: "Your voucher redeemed successfully")
                                let vc = self.VC?.storyboard?.instantiateViewController(withIdentifier: "HYT_SuccessMessageVC") as? HYT_SuccessMessageVC
                                vc?.modalTransitionStyle = .crossDissolve
                                vc?.modalPresentationStyle = .overFullScreen
                                vc?.successMessage = "Your voucher redeemed successfully".localiz()
                                vc?.delegate = self
                                self.VC?.present(vc!, animated: true)
                                self.VC?.dashboardApi()
                                self.VC?.stopLoading()
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.VC?.view.makeToast("something_went_wrong".localiz(),duration: 2.0,position: .center)
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
                        print("Voucher Redeemption error",error?.localizedDescription)
                    }
                }
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
                                self.VC?.availableBalanceLbl.text = "\(Int(result?.objCustomerDashboardList?[0].overAllPoints ?? 0))"
                        self.VC?.totalRedeemPoint = Int(result?.objCustomerDashboardList?[0].overAllPoints ?? 0)
                                UserDefaults.standard.setValue(result?.objCustomerDashboardList?[0].overAllPoints ?? "", forKey: "TotalPoints")
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
