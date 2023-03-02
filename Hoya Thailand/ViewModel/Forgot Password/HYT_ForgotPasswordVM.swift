//
//  HYT_ForgotPasswordVM.swift
//  Hoya Thailand
//
//  Created by syed on 25/02/23.
//

import Foundation


class HYT_ForgotPasswordVM{
    weak var VC: HYT_ForgotPasswordVC?
    var requestAPIs = RestAPI_Requests()
    var timmer = Timer()
    var count = 0
    var otpNumber = ""
    
    func verifyMobileNumberAPI(paramters: JSON){
        self.VC?.startLoading()
        let url = URL(string: checkUserExistencyURL)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "TOKEN") ?? "")", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do{
                let str = String(decoding: data, as: UTF8.self) as String?
                 print(str, "- Mobile Number Exists")
                if str ?? "" != "1"{
                    DispatchQueue.main.async{
                        self.VC?.stopLoading()
                        self.VC?.view.makeToast("Invalid membership Id / Mobile number", duration: 2.0, position: .center)
                    }
                }else{
                    DispatchQueue.main.async{
                        self.getOtpApi()
                        
                        self.VC?.stopLoading()
                    }
                }
                 }catch{
                     DispatchQueue.main.async{
                         self.VC?.stopLoading()
                         print("mobile Number existancy Error",error.localizedDescription)
                     }
                    
            }
        })
        task.resume()
    }
    
//    MARK: - GET OTP API
    func getOtpApi(){
        let parameter : [String : Any] = [
                "MerchantUserName": "MSPDemoAdmin",
                "MobileNo": self.VC?.membershipIdTF.text,
                "OTPType": "Enrollment",
                "UserId": -1,
                "UserName": ""
        ]
        self.VC?.startLoading()
        requestAPIs.getOTP_API(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.submitOtpView.isHidden = false
                        self.VC?.sendOtpView.isHidden = true
                        self.timmer.invalidate()
                        self.count = 60
                        self.timmer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                        self.VC?.sendotp = 1
                        self.otpNumber = result?.returnMessage ?? ""
                        print("OTP - " , self.otpNumber)
                        self.VC?.stopLoading()
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.sendotp = 0
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
    
    
    
    func sendPasswordToMobileNumberApi(){
        
        let paramters : [String : Any] = [
        
                    "MerchantUserName":"HoyaThMerchantDemo",
                    "UserName":self.VC?.membershipIdTF.text
                
        ]
        
        self.VC?.startLoading()
        let url = URL(string: forgotPasswordUrl)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "TOKEN") ?? "")", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do{
                let str = String(decoding: data, as: UTF8.self) as? String
                 print(str, "- Mobile Number Exists")
                if str ?? "" != "true"{
                    DispatchQueue.main.async{
                        self.VC?.stopLoading()
                        self.VC?.view.makeToast("please try after some time", duration: 2.0, position: .center)
                    }
                }else{
                    DispatchQueue.main.async{
                        self.VC?.successMessagePopUp(message: "Pin has been sent to registered mobile number")
                        self.VC?.navigationController?.popViewController(animated: true)
                        self.VC?.stopLoading()
                    }
                }
                 }catch{
                     DispatchQueue.main.async{
                         self.VC?.stopLoading()
                         print("mobile Number existancy Error",error.localizedDescription)
                     }
                    
            }
        })
        task.resume()
    }
    
 
    @objc func update() {
        if(self.count > 1) {
            self.count = Int(self.count) - 1
            self.VC?.timmerLbl.text = "00:\(self.count)"
            self.VC?.timmerLbl.isHidden = false
            self.VC?.resendBtn.isHidden = true
           
        }else{
            self.timmer.invalidate()
            self.VC?.sendotp = 0
            self.VC?.timmerLbl.text = "00:00"
            self.VC?.timmerLbl.isHidden = true
            self.VC?.resendBtn.isHidden = false
        }
    }
}
