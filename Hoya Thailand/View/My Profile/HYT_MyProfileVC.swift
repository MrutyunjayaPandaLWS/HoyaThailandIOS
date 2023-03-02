//
//  HYT_MyProfileVC.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit
import Toast_Swift

class HYT_MyProfileVC: BaseViewController, DropdownDelegate, DatePickerDelegate, OtpDelegate {
    func didTappedDOA(date: String) {
        selectAnniversarydateLbl.text = date
    }
    
    func didTappedRoleBtn(item: HYT_DropDownVC) {
    }
    
    func didTappedSalesRepresentative(item: HYT_DropDownVC) {
    }
    
    func sendOtp(item: HYT_OtpVC) {
        mobileNumberTF.text = item.newNumberTF.text
    }
    
    func didTappedFromDate(date: String) {
    }
    
    func didTappedToDate(date: String) {
    }
    
    func didTappedDOB(date: String) {
        selectDateLbl.text = date
    }
    
    func didTappedPromotionName(item: HYT_DropDownVC) {
    }
    
    func didTappedGenderBtn(item: HYT_DropDownVC) {
        selectGenderLbl.text = item.genderName
    }
    
    func didTappedAccountType(item: HYT_DropDownVC) {
    }
    

    @IBOutlet weak var backBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var salesRepresentativeTF: UITextField!
    @IBOutlet weak var salesRepresentativeLbl: UILabel!
    @IBOutlet weak var idCardNumberTF: UITextField!
    @IBOutlet weak var idCardNumberLbl: UILabel!
    @IBOutlet weak var storeNameTF: UITextField!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeIDTF: UITextField!
    @IBOutlet weak var storeIDLbl: UILabel!
    @IBOutlet weak var roleTF: UITextField!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var membershipIDTF: UITextField!
    @IBOutlet weak var membershipIdLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var generalInfoView: UIView!
    @IBOutlet weak var generalInfoLineLbl: UILabel!
    @IBOutlet weak var generalInfoBtn: UIButton!
    @IBOutlet weak var personalInfoView: UIView!
    @IBOutlet weak var personalInfoLineLbl: UILabel!
    @IBOutlet weak var personalInfoBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var personalInformationTopHeight: NSLayoutConstraint!
    @IBOutlet weak var personalInformationView: UIView!
    @IBOutlet weak var generalInformationView: UIView!
    
    @IBOutlet weak var selectAnniversarydateLbl: UILabel!
    
    @IBOutlet weak var selectGenderLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var selectDateLbl: UILabel!
    @IBOutlet weak var dateTitleLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var firstNameLbl: UILabel!
    var registerationNo : Int = 0
    var backbtnWidth = 0
    var VM = HYT_ProfileVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        backBtnWidth.constant = CGFloat(backbtnWidth)
    }

    override func viewWillAppear(_ animated: Bool) {
        personalInformationTopHeight.constant = 20
        personalInformationView.isHidden = true
        generalInformationView.isHidden = false
        updateBtn.isHidden = true
        personalInfoBtn.titleLabel?.textColor = .lightGray
        generalInfoLineLbl.backgroundColor = primaryColor
        membershipIDTF.isUserInteractionEnabled = false
        roleTF.isUserInteractionEnabled = false
        storeIDTF.isUserInteractionEnabled = false
        storeNameTF.isUserInteractionEnabled = false
        salesRepresentativeTF.isUserInteractionEnabled = false
        idCardNumberTF.isUserInteractionEnabled = false
        customerGeneralInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        backbtnWidth = 0
        
    }
    
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedMobilenumberEditBtn(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_OtpVC") as? HYT_OtpVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.flags = "Otp"
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedDOBbtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DatePickerVC") as? HYT_DatePickerVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.flags = "DOB"
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedSelectGenderBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DropDownVC") as? HYT_DropDownVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.flags = "gender"
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedAnniversaryDateBtn(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DatePickerVC") as? HYT_DatePickerVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.flags = "DOA"
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedUpdateBtn(_ sender: UIButton) {
        if firstNameTF.text?.count == 0{
            self.view.makeToast("Enter the first name", duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0{
            self.view.makeToast("Enter the last name", duration: 2.0, position: .center)
        }else if mobileNumberTF.text?.count == 0{
            self.view.makeToast("Enter the number", duration: 2.0, position: .center)
        }else if emailTF.text?.count == 0 {
            self.view.makeToast("Enter the email", duration: 2.0, position: .center)
        }else if selectDateLbl.text == "Selcet DOB"{
            self.view.makeToast("Select the DOB ", duration: 2.0, position: .center)
        }else if selectGenderLbl.text == "Select gender"{
            self.view.makeToast("Select the gender", duration: 2.0, position: .center)
        }else if selectAnniversarydateLbl.text == "Select Date"{
            self.view.makeToast("Select the Anversary Date", duration: 2.0, position: .center)
        }else{
            profileUpdate_Api()
        }
        
    }
    
    @IBAction func didTappedPersonalInfoBtn(_ sender: UIButton) {
        personalInformationView.isHidden = false
        generalInformationView.isHidden = true
        personalInfoLineLbl.backgroundColor = primaryColor
        generalInfoLineLbl.backgroundColor = primaryColor2
        generalInfoBtn.titleLabel?.textColor = .lightGray
        personalInfoBtn.titleLabel?.textColor = primaryColor
        updateBtn.isHidden = false
        
    }
    
    @IBAction func didTappedGeneralInfoBtn(_ sender: UIButton) {
        personalInformationView.isHidden = true
        generalInformationView.isHidden = false
        personalInfoLineLbl.backgroundColor = primaryColor2
        generalInfoLineLbl.backgroundColor = primaryColor
//        generalInfoBtn.titleLabel?.textColor = primaryColor
        generalInfoBtn.titleLabel?.textColor = primaryColor
        personalInfoBtn.titleLabel?.textColor = .lightGray
        updateBtn.isHidden = true

    }
    
    
    func customerGeneralInfo(){
        let parameter : [String : Any] = [
            
               "ActionType": "6",
               "CustomerId": "46"//customerTypeID
        ]
        
        self.VM.customerGeneralInfo(parameter: parameter)
    }
    
//    MARK: - PROFILE UPDATE API
    func profileUpdate_Api(){
        let parameter : [String : Any] = [
                "ActionType": "4",
                "ActorId": userId,
                "ObjCustomerJson": [
                    "Address1": "",
                    "CustomerId": customerTypeID,
                    "FirstName": firstNameTF.text ?? "",
                    "lastname": lastNameTF.text ?? "",
                    "Email": emailTF.text ?? "",
                    "JDOB": selectDateLbl.text ?? "",
                    "Mobile": mobileNumberTF.text ?? "",
                    "RegistrationSource": registerationNo
                ],
                "ObjCustomerDetails":[
                    "IsNewProfilePicture":1,
                    "Anniversary": selectAnniversarydateLbl.text ?? "",
                    "Gender": selectGenderLbl.text ?? ""
                ]
        ]
        
        self.VM.peofileUpdate(parameter: parameter)
    }
}
