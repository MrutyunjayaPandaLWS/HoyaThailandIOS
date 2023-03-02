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
}
