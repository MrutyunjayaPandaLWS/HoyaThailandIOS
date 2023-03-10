//
//  HYT_RegisterOtpVM.swift
//  Hoya Thailand
//
//  Created by syed on 01/03/23.
//

import Foundation
import Toast_Swift


class HYT_RegisterOtpVM{
    weak var VC: HYT_RegisterOtpVC?
    var requestAPIs = RestAPI_Requests()
    var timmer = Timer()
    var count = 0
    var otpNumber = ""
    
    //    MARK: - GET OTP API
    func getOtpApi(parameter: JSON){
            self.VC?.startLoading()
            requestAPIs.getOTP_API(parameters: parameter) { result, error in
                if error == nil{
                    if result != nil{
                        DispatchQueue.main.async {
                            self.timmer.invalidate()
                            self.count = 60
                            self.timmer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
//                            self.VC?.sendotp = 1
                            self.otpNumber = result?.returnMessage ?? ""
                            print("OTP - " , self.otpNumber)
                            self.VC?.stopLoading()
                        }
                    }else{
                        DispatchQueue.main.async {
//                            self.VC?.sendotp = 0
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
    
    @objc func update() {
        if(self.count > 1) {
            self.count = Int(self.count) - 1
            self.VC?.timmerLbl.text = "00:\(self.count)"
            self.VC?.timmerLbl.isHidden = false
//            self.VC?.resendBtn.isHidden = true
           
        }else{
            self.timmer.invalidate()
//            self.VC?.sendotp = 0
            self.VC?.timmerLbl.text = "00:00"
            self.VC?.timmerLbl.isHidden = true
//            self.VC?.resendBtn.isHidden = false
        }
    }
}
