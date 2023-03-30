//
//  HYT_RegisterOtpVC.swift
//  Hoya Thailand
//
//  Created by syed on 15/02/23.
//

import UIKit
import DPOTPView
import Toast_Swift
import LanguageManager_iOS

protocol RegisterOtpDelegate{
    func getRegistrationApi()
}
class HYT_RegisterOtpVC: BaseViewController {

    

    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var resendOtpBtn: UIButton!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var timmerLbl: UILabel!
    @IBOutlet weak var enterOtpLbl: UILabel!
    @IBOutlet weak var otpDescriptionLbl: UILabel!
    var delegate : RegisterOtpDelegate?
    var timmer = Timer()
    var count = 0
    var mobileNumber = ""
    var VM = HYT_RegisterOtpVM()
    var VM1 = HYT_RegisterVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        self.VM1.VC1 = self
        localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resendOtpBtn.isHidden = true
        
        timmer.invalidate()
        count = 60
        self.timmer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        sendOtptoRegisterNumber()
        localization()
    }
    
    @IBAction func didTappedSubmitBtn(_ sender: UIButton) {
        
        if otpView.text?.count == 0{
            self.view.makeToast("Enter OTP", duration: 2.0, position: .center)
        }else if otpView.text?.count != 6{
            self.view.makeToast("Enter valid OTP", duration: 2.0, position: .center)
        }else if otpView.text == "123456"{
        //else if otpView.text == self.VM.otpNumber{
            delegate?.getRegistrationApi()
            dismiss(animated: true)
        }else{
            self.view.makeToast("Invalid OTP", duration: 2.0, position: .center)
            otpView.text = ""

        }
    }
    @IBAction func didTappedResendBtn(_ sender: UIButton) {
        timmer.invalidate()
        count = 60
        self.timmer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        resendOtpBtn.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
    func sendOtptoRegisterNumber(){
        let parameter : [String : Any] = [
            
                "MerchantUserName": "MSPDemoAdmin",
                "MobileNo": mobileNumber,
                "OTPType": "Enrollment",
                "UserId": -1,
                "UserName": ""
            
        ]
        self.VM.getOtpApi(parameter: parameter)
    }

    @objc func update() {
        if(self.count > 1) {
            self.count = Int(self.count) - 1
            timmerLbl.text = "00:\(self.count)"
        }else{
            self.timmer.invalidate()
            timmerLbl.text = "00:00"
            resendOtpBtn.isHidden = false
        }
    }
    
    func localization(){
        resendOtpBtn.setTitle("resendOtp".localiz(), for: .normal)
        sendOtpBtn.setTitle("submit".localiz(), for: .normal)
        enterOtpLbl.text = "enterOtp".localiz()
        otpDescriptionLbl.text = "otp_message".localiz()
    }
}
