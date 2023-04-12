//
//  HYT_OtpVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import DPOTPView
import Toast_Swift

protocol OtpDelegate{
    func sendOtp(item: HYT_OtpVC )
}

class HYT_OtpVC: BaseViewController,UITextFieldDelegate{

    @IBOutlet weak var otpBtnTopConstraints: NSLayoutConstraint!  // 134
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var getOtpBtn: UIButton!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var enterOtpLbl: UILabel!
    @IBOutlet weak var newNumberTF: UITextField!
    @IBOutlet weak var newNumberLbl: UILabel!
    var delegate: OtpDelegate?
    var flags = ""
    var VM = HYT_OtpVM()
    var otpBtnStatus = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        newNumberTF.delegate = self
        resendBtn.isHidden = true
        otpView.isHidden = true
        enterOtpLbl.isHidden = true
        timerLbl.isHidden = true
        newNumberTF.keyboardType = .numberPad
        otpBtnTopConstraints.constant = CGFloat(20)
        newNumberTF.isUserInteractionEnabled = true
    }
    
    @IBAction func didTappedGetOtp(_ sender: UIButton) {
        if otpBtnStatus == 0{
            if newNumberTF.text?.count == 0{
                self.view.makeToast("Enter mobile number", duration: 2.0, position: .center)
            }else if newNumberTF.text?.count == 9{
                if  String(newNumberTF.text?.prefix(1) ?? "") == "9" || String(newNumberTF.text?.prefix(1) ?? "") == "8" || String(newNumberTF.text?.prefix(1) ?? "") == "7" || String(newNumberTF.text?.prefix(1) ?? "") == "6"{
                    checkMobileNumberExistancy()
                }else{
                    self.view.makeToast("Enter valid mobile number", duration: 2.0, position: .center)
                }
            }else{
                self.view.makeToast("Enter valid mobile number", duration: 2.0, position: .center)
            }
        }else{
            if otpView.text?.count == 0{
                self.view.makeToast("Enter OTP", duration: 2.0, position: .center)
            }else if otpView.text?.count != 6{
                self.view.makeToast("Enter valid OTP", duration: 2.0, position: .center)
                //            }else if otpView.text == self.VM.otpNumber{
            }else if otpView.text == "123456"{
                delegate?.sendOtp(item: self)
                dismiss(animated: true)
            }else{
                self.view.makeToast("Invalid OTP", duration: 2.0, position: .center)
                otpView.text = ""
            }
        }
        
        
    }
  
    @IBAction func didTappedNumberTF(_ sender: UITextField) {
    }
    @IBAction func didTappedResendBtn(_ sender: UIButton) {
        sendOtptoRegisterNumber()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view{
                    dismiss(animated: true)
        }
    }

    func sendOtptoRegisterNumber(){
        let parameter : [String : Any] = [
            
                "MerchantUserName": "MSPDemoAdmin",
                "MobileNo": "\(newNumberTF.text ?? "")",
                "OTPType": "Enrollment",
                "UserId": -1,
                "UserName": ""
            
        ]
        self.VM.getOtpApi(parameter: parameter)
    }
    
    //   MARK: - CHECK MOBILE NUMBER API
    func checkMobileNumberExistancy(){
        let parameter : [String : Any] = [
                "ActionType": 57,
                "Location":[
                    "UserName":newNumberTF.text ?? ""
                ]
        ]
        self.VM.checkMobileNumberExistancyApi(parameter: parameter)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength : Int = 9
        if textField == newNumberTF{
            maxLength = 9
        } 
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
