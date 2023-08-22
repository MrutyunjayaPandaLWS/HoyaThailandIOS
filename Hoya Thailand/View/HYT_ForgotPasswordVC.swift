//
//  HYT_ForgotPasswordVC.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit
import DPOTPView
import Toast_Swift
import LanguageManager_iOS

class HYT_ForgotPasswordVC: BaseViewController,UITextFieldDelegate, LanguageDropDownDelegate {
    func didtappedLanguageBtn(item: HYT_LanguageDropDownVC) {
        selectLanguageLbl.text = item.language
        localization()
    }
    

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var timmerLbl: UILabel!
    @IBOutlet weak var sendOtpView: UIView!
    @IBOutlet weak var submitOtpView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var enterOtpLbl: UILabel!
    @IBOutlet weak var backToLoginLbl: UILabel!
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var membershipIdTF: UITextField!
    @IBOutlet weak var membershipIdLbl: UILabel!
    @IBOutlet weak var forgotPWDescriptionLbl: UILabel!
    @IBOutlet weak var forgotPasswordLbl: UILabel!
    @IBOutlet weak var selectLanguageLbl: UILabel!
    
//    var timmer = Timer()
//    var count = 0
    var mobileNumber = ""
    var sendotp = 0
    var VM = HYT_ForgotPasswordVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        membershipIdTF.delegate = self
        submitOtpView.isHidden = true
        resendBtn.isHidden = true
        localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectLanguageLbl.text = selectedLanguage
        localization()
    }

    @IBAction func didTappedBackToLogin(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func didTappedSelectLanguage(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_LanguageDropDownVC") as? HYT_LanguageDropDownVC
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        vc?.delegate = self
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedSubmit(_ sender: UIButton) {
        
        if otpView.text?.count == 0{
            self.view.makeToast("enterOtp".localiz(), duration: 2.0, position: .center)
        }else if otpView.text?.count != 6{
            self.view.makeToast("Invalid OTP", duration: 2.0, position: .center)
        }
//        else if sendotp == 0{
//            self.view.makeToast("Resend OTP", duration: 2.0, position: .center)
//        }
//        else if otpView.text == "123456" {
////        else if otpView.text == self.VM.otpNumber{
//            self.VM.sendPasswordToMobileNumberApi()
//        }
        else{
//            self.view.makeToast("Wrong OTP", duration: 2.0, position: .center)
//            otpView.text = ""
            self.VM.serverOTP(mobileNumber: self.mobileNumber, otpNumber: otpView.text ?? "")

        }
    }
    @IBAction func didTappedResendBtn(_ sender: UIButton) {
        self.VM.getOtpApi()
//        timmer.invalidate()
//        count = 60
//        self.timmer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    @IBAction func didTappedSendOtp(_ sender: UIButton) {
        if membershipIdTF.text?.count == 0{
            self.view.makeToast("userId_toast_message_1".localiz(), duration: 2.0, position: .center)
        }else{
            checkmobileNumberExistancy()
            
        }
    }
    
    
    func checkmobileNumberExistancy(){
        let parameter : [String : Any] = [
            "ActionType": "57",
            "Location": [
                "UserName" : "\(membershipIdTF.text ?? "")"
            ]
        ]
        self.VM.verifyMobileNumberAPI(paramters: parameter)
    }
    
//    @objc func update() {
//        if(self.count > 1) {
//            self.count = Int(self.count) - 1
//            timmerLbl.text = "00:\(self.count)"
//            timmerLbl.isHidden = false
//            resendBtn.isHidden = true
//
//        }else{
//            self.timmer.invalidate()
//            timmerLbl.text = "00:00"
//            timmerLbl.isHidden = true
//            resendBtn.isHidden = false
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength : Int = 10
        if textField == membershipIdTF{
            maxLength = 10
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    private func localization(){
        forgotPasswordLbl.text = "forgot_password".localiz()
        forgotPWDescriptionLbl.text = "forgot_password_info".localiz()
        membershipIdLbl.text = "userId".localiz()
        membershipIdTF.placeholder = "userId_toast_message".localiz()
        sendOtpBtn.setTitle("sendOtp".localiz(), for: .normal)
        backToLoginLbl.text = "back_Login".localiz()
        selectLanguageLbl.text = "language".localiz()
        resendBtn.setTitle("resendOtp".localiz(), for: .normal)
        submitBtn.setTitle("submit".localiz(), for: .normal)
    }
}
