//
//  HYT_OtpVM.swift
//  Hoya Thailand
//
//  Created by syed on 01/03/23.
//

import Foundation
class HYT_OtpVM{
    weak var VC: HYT_OtpVC?
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
                            self.VC?.otpView.isHidden = false
                            self.VC?.enterOtpLbl.isHidden = false
                            self.VC?.timerLbl.isHidden = false
                            self.VC?.otpBtnTopConstraints.constant = CGFloat(124)
                            self.VC?.getOtpBtn.setTitle("Submit", for: .normal)
                            self.VC?.newNumberTF.isUserInteractionEnabled = false
                            self.VC?.otpBtnStatus = 1
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
            self.VC?.timerLbl.text = "00:\(self.count)"
            self.VC?.timerLbl.isHidden = false
            self.VC?.resendBtn.isHidden = true
           
        }else{
            self.timmer.invalidate()
//            self.VC?.sendotp = 0
            self.VC?.timerLbl.text = "00:00"
            self.VC?.timerLbl.isHidden = true
            self.VC?.resendBtn.isHidden = false
        }
    }
    
    //    MARK: - CHECK MOBILE NUMBER EXISTANCY
    func checkMobileNumberExistancyApi(parameter : JSON){
        self.VC?.startLoading()
        requestAPIs.storeMobileNumberExistancy_Api(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    
                    if result?.returnValue == 1{
                        DispatchQueue.main.async {
                            self.VC?.view.makeToast("The Mobile number allready exists", duration: 2.0, position: .center)
                            self.VC?.stopLoading()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.VC?.sendOtptoRegisterNumber()
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
                }
            }
        }
    }
}
