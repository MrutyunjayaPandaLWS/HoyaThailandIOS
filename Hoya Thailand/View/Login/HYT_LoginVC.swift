//
//  HYT_LoginVC.swift
//  Hoya Thailand
//
//  Created by syed on 09/02/23.
//

import UIKit
import Toast_Swift

class HYT_LoginVC: BaseViewController, LanguageDropDownDelegate,UITextFieldDelegate{
    
    func didtappedLanguageBtn(item: HYT_LanguageDropDownVC) {
        languageLbl.text = item.language
        if item.language == "English"{
            UserDefaults.standard.set("EN", forKey: "LanguageName")
            UserDefaults.standard.synchronize()
        }else{
            UserDefaults.standard.set("TH", forKey: "LanguageName")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var securePasswordBtn: UIButton!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var needHelpBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var registerLbl: UILabel!
    @IBOutlet weak var accountStatusLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var membershipIdTF: UITextField!
    @IBOutlet weak var membershipIDLbl: UILabel!
    @IBOutlet weak var loginInfoLbl: UILabel!
    @IBOutlet weak var loginLbl: UILabel!
    
    var mobileNumberExistancy = -1
    var VM = HYT_LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        membershipIdTF.delegate = self
        passwordTF.delegate = self
        passwordTF.isSecureTextEntry = true
        self.securePasswordBtn.setImage(UIImage(named: "close-eye"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.VM.tokendata()
        languageLbl.text = selectedLanguage
        
    }
    
    @IBAction func didTappedRegisterBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HYT_RegisterVC") as? HYT_RegisterVC
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didTappedmobileNumberTF(_ sender: UITextField) {
        if membershipIdTF.text?.count != 0{
            print(membershipIdTF.text)
            mobileNumberExistancyApi()
        }else{
            self.view.makeToast("Enter mobile number/membership id", duration: 2.0, position: .center)
        }
        
    }
    @IBAction func didTappedSubmitBtn(_ sender: UIButton) {
        if membershipIdTF.text?.count == 0 {
            self.view.makeToast("Enter mobile number/membership id", duration: 2.0, position: .center)
        }else if passwordTF.text?.count == 0{
            self.view.makeToast("Enter password", duration: 2.0, position: .center)
        }else if passwordTF.text?.count != 6{
            self.view.makeToast("Enter a valid password", duration: 2.0, position: .center)
        }else{
            loginSubmissionApi()
        }

    }
    
    @IBAction func didTappedNeedHelpBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_HelpVC") as? HYT_HelpVC
        navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func didTappedLanguageSelectBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_LanguageDropDownVC") as? HYT_LanguageDropDownVC
        vc!.modalTransitionStyle = .crossDissolve
        vc!.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
       present(vc!, animated: true)
    }
    
    @IBAction func didTappedSecurePasswordBtn(_ sender: Any) {
    
        if passwordTF.isSecureTextEntry == false{
            passwordTF.isSecureTextEntry = true
            self.securePasswordBtn.setImage(UIImage(named: "close-eye"), for: .normal)
        }else{
            self.securePasswordBtn.setImage(UIImage(named: "eye_open"), for: .normal)
            passwordTF.isSecureTextEntry = false
        }
    }
    
    @IBAction func didTappedForgotPasswordBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_ForgotPasswordVC") as? HYT_ForgotPasswordVC
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func mobileNumberExistancyApi(){
        let parameter : [String : Any] = [
                "ActionType": "57",
                "Location": [
                    "UserName" : "\(membershipIdTF.text ?? "")"
                ]
        ]
        VM.verifyMobileNumberAPI(paramters: parameter)
//        56875434356
    }
    
    
    func loginSubmissionApi(){
        let parameter : [String : Any] = [
            
                "Browser": "Android",
                "LoggedDeviceName": "Android",
                "Password": passwordTF.text ?? "",
                "PushID":"",
                "SessionId": "HOYA",
                "UserActionType": "GetPasswordDetails",
                "UserName": membershipIdTF.text ?? "",
                "UserType": "Customer"
            
        ]
        VM.loginSubmissionApi(parameter: parameter)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength : Int = 10
        if textField == membershipIdTF{
            maxLength = 14
        }else if textField == passwordTF{
            maxLength = 6
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
}

