//
//  HYT_MyProfileVC.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit
import Toast_Swift
import LanguageManager_iOS

class HYT_MyProfileVC: BaseViewController, DropdownDelegate, DateSelectedDelegate, OtpDelegate, SuccessMessageDelegate, popMessage2Delegate, InternetCheckDelgate {

    func interNetIsON(item: IOS_Internet_Check) {
        customerGeneralInfo()
    }
    
    func didTappedOKBtn(item: SuccessMessage2 ) {
        if item.flags == "1"{
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            if #available(iOS 13.0, *){
                let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                sceneDelegate.setInitialViewAsRootViewController()
            }else{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.setInitialViewAsRootViewController()
            }

        }else if item.flags == "0"{
            
            let parameters : [String : Any] = [
            "ActionType": 1,
            "userid":"\(self.userId)"
        ] as [String : Any]
        print(parameters)
            self.VM.deleteAccount(parameters: parameters) { response in
                DispatchQueue.main.async {
                    print(response?.returnMessage ?? "-1")
                    if response?.returnMessage ?? "-1" == "1"{
                        DispatchQueue.main.async{
                            DispatchQueue.main.async{
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_SuccessMessageVC") as? HYT_SuccessMessageVC
                                vc!.delegate = self
                                vc!.successMessage = "Account_deleted_successfully".localiz()
                                vc!.itsComeFrom = "0"
                                vc!.modalPresentationStyle = .overCurrentContext
                                vc!.modalTransitionStyle = .crossDissolve
                                self.present(vc!, animated: true, completion: nil)
                                }
                            }
                    }else{
                        DispatchQueue.main.async{
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_SuccessMessageVC") as? HYT_SuccessMessageVC
                            vc!.delegate = self
                            vc!.successMessage = "something_went_wrong".localiz()
                            vc!.itsComeFrom = ""
                            vc!.modalPresentationStyle = .overCurrentContext
                            vc!.modalTransitionStyle = .crossDissolve
                            self.present(vc!, animated: true, completion: nil)
                            }
                    }
                  self.stopLoading()
                    }
            }
        }

    }
    
    func goToLoginPage(item: HYT_SuccessMessageVC) {
        if item.itsComeFrom == "0"{
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            if #available(iOS 13.0, *){
                let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                sceneDelegate.setInitialViewAsRootViewController()
            }else{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.setInitialViewAsRootViewController()
            }

        }
    }
    
    
    func acceptDate(_ vc: HYT_DatePickerVC) {
        if vc.isComeFrom == "DOB"{
            selectDateLbl.text = vc.selectedDate
            DOB = vc.selectedDate
        }else{
            selectAnniversarydateLbl.text = vc.selectedDate
            aniversaryDate = vc.selectedDate
            
        }
    }
    
    func declineDate(_ vc: HYT_DatePickerVC) {}
    
   
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
        gender =  item.genderName
    }
    
    func didTappedAccountType(item: HYT_DropDownVC) {
    }
    

    @IBOutlet weak var shadowLogoutView: UIView!
    @IBOutlet weak var logoutLbl: UILabel!
    
    @IBOutlet weak var deleteAccountLbl: UILabel!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var anniversaryDateLbl: UILabel!
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
//    @IBOutlet weak var personalInformationTopHeight: NSLayoutConstraint!
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
    var aniversaryDate = ""
    var gender = ""
    var DOB = ""
    var VM = HYT_ProfileVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        logoutView.layer.maskedCorners =  [.layerMinXMaxYCorner]
        backBtnWidth.constant = CGFloat(backbtnWidth)
    }

    override func viewWillAppear(_ animated: Bool) {
//        personalInformationTopHeight.constant = 20
        self.logoutView.isHidden = true
        self.shadowLogoutView.isHidden = true
        personalInformationView.isHidden = true
        generalInformationView.isHidden = false
        updateBtn.isHidden = true
        personalInfoLineLbl.backgroundColor = .lightGray
        generalInfoLineLbl.backgroundColor = primaryColor
        personalInfoBtn.setTitleColor(.lightGray, for: .normal)
        generalInfoBtn.setTitleColor(primaryColor, for: .normal)
        membershipIDTF.isUserInteractionEnabled = false
        roleTF.isUserInteractionEnabled = false
        storeIDTF.isUserInteractionEnabled = false
        storeNameTF.isUserInteractionEnabled = false
        salesRepresentativeTF.isUserInteractionEnabled = false
        idCardNumberTF.isUserInteractionEnabled = false
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.delegate = self
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
         customerGeneralInfo()
        }
//        customerGeneralInfo()
        localization()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.shadowLogoutView{
            self.logoutView.isHidden = true
            self.shadowLogoutView.isHidden = true
        }
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
        vc?.isComeFrom = "DOB"
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
        vc?.isComeFrom = "1"
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedSettingBtn(_ sender: Any) {
        logoutView.isHidden ? (logoutView.isHidden =  false) : (logoutView.isHidden = true)
        shadowLogoutView.isHidden ? (shadowLogoutView.isHidden =  false) : (shadowLogoutView.isHidden = true)
    }
    
    @IBAction func didTappedDeleteaccount(_ sender: Any) {
        self.logoutView.isHidden = true
        self.shadowLogoutView.isHidden = true
        deleteAccount()
    }
    
    @IBAction func didTappedLogoutBtn(_ sender: Any) {
        self.logoutView.isHidden = true
        self.shadowLogoutView.isHidden = true
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SuccessMessage2") as? SuccessMessage2
        vc!.delegate = self
        vc!.message = "Are you sure you want to Logout ?".localiz()
        vc?.btnName = "Logout".localiz()
        vc?.vcTitle = "Logout".localiz()
        vc!.flags = "1"
        vc!.modalPresentationStyle = .overCurrentContext
        vc!.modalTransitionStyle = .crossDissolve
        self.present(vc!, animated: true, completion: nil)
 
//        let alert = UIAlertController(title: "Logout".localiz(), message: "Are you sure you want to Logout ?".localiz(), preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: { UIAlertAction in
//
//
//
//        }))
//        alert.addAction(UIAlertAction(title: "No".localiz(), style: UIAlertAction.Style.default, handler: nil))
//    self.present(alert, animated: true, completion: nil)
  
        
        
    }
    
    
    @IBAction func didTappedUpdateBtn(_ sender: UIButton) {
        if firstNameTF.text?.count == 0{
            self.view.makeToast("firstName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0{
            self.view.makeToast("lastName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if mobileNumberTF.text?.count == 0{
            self.view.makeToast("mobileNumber_toast_message".localiz(), duration: 2.0, position: .center)
        }
//        else if emailTF.text?.count == 0 {
//            self.view.makeToast("Enter the email", duration: 2.0, position: .center)
//        }
//        else if selectDateLbl.text == "DOB_toast_message".localiz(){
//            self.view.makeToast("DOB_toast_message".localiz(), duration: 2.0, position: .center)
//        }
//        else if selectGenderLbl.text == "Select gender"{
//            self.view.makeToast("gender_toast_message".localiz(), duration: 2.0, position: .center)
//        }
//        else if selectAnniversarydateLbl.text == "date_of_aniversary_toast_message".localiz(){
//            self.view.makeToast("date_of_aniversary_toast_message".localiz(), duration: 2.0, position: .center)
//        }
        else{
            profileUpdate_Api()
        }
        
    }
    
    @IBAction func didTappedPersonalInfoBtn(_ sender: UIButton) {
        personalInformationView.isHidden = false
        generalInformationView.isHidden = true
        personalInfoLineLbl.backgroundColor = primaryColor
        generalInfoLineLbl.backgroundColor = primaryColor2
        personalInfoBtn.setTitleColor(primaryColor, for: .normal)
        generalInfoBtn.setTitleColor(.lightGray, for: .normal)
        updateBtn.isHidden = false
        
    }
    
    @IBAction func didTappedGeneralInfoBtn(_ sender: UIButton) {
        personalInformationView.isHidden = true
        generalInformationView.isHidden = false
        personalInfoLineLbl.backgroundColor = primaryColor2
        generalInfoLineLbl.backgroundColor = primaryColor
        personalInfoBtn.setTitleColor(.lightGray, for: .normal)
        generalInfoBtn.setTitleColor(primaryColor, for: .normal)
        updateBtn.isHidden = true

    }
    
    
    func customerGeneralInfo(){
        let parameter : [String : Any] = [
            
               "ActionType": "6",
               "CustomerId": "\(self.userId)"//customerTypeID
        ]
        print(parameter,"customerGeneralInfo")
        self.VM.customerGeneralInfo(parameter: parameter)
    }
    
//    MARK: - PROFILE UPDATE API
    func profileUpdate_Api(){
        let parameter : [String : Any] =
//        [
//                "ActionType": "4",
//                "ActorId": userId,
//                "ObjCustomerJson": [
//                    "Address1": "",
//                    "CustomerId": customerTypeID,
//                    "FirstName": firstNameTF.text ?? "",
//                    "lastname": lastNameTF.text ?? "",
//                    "Email": emailTF.text ?? "",
//                    "JDOB": selectDateLbl.text ?? "",
//                    "Mobile": mobileNumberTF.text ?? "",
//                    "RegistrationSource": registerationNo
//                ],
//                "ObjCustomerDetails":[
//                    "IsNewProfilePicture":1,
//                    "Anniversary": selectAnniversarydateLbl.text ?? "",
//                    "Gender": selectGenderLbl.text ?? ""
//                ]
//        ]
        
        
        [
            "ActionType": "4",
            "ActorId": userId,
            "ObjCustomerJson": [
                "Address1": "",
                "CustomerId": customerTypeID,
                "FirstName": firstNameTF.text ?? "",
                "lastname":lastNameTF.text ?? "",
                "Email": emailTF.text ?? "",
                "DOB": DOB,
                "Mobile": mobileNumberTF.text ?? "",
                "RegistrationSource": "3",
                "rELATED_PROJECT_TYPE" : "HOYA",
                "customerTypeID": customerTypeID
            ] as [String : Any],
            "ObjCustomerDetails": [
                "IsNewProfilePicture":1,
                "Anniversary": aniversaryDate,
                "Gender": gender
            ] as [String : Any]
        ]
        print(parameter,"profile update")
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
//            self.VM.VC?.profileUpdate_Api()
            self.VM.peofileUpdate(parameter: parameter)
        }
//        self.VM.peofileUpdate(parameter: parameter)
    }
    
    private func localization(){
        titleLbl.text = "myProfile".localiz()
        membershipIdLbl.text = "membershipId".localiz()
        membershipIDTF.placeholder = "membershipId_toast_message".localiz()
        roleLbl.text = "role".localiz()
        roleTF.placeholder = "select_role".localiz()
        storeNameLbl.text = "storeName".localiz()
        storeNameTF.placeholder = "storeName_toast_message".localiz()
        storeIDLbl.text = "stoeId".localiz()
        storeIDTF.placeholder = "storeId_toast_message".localiz()
        idCardNumberLbl.text = "idCardNumber".localiz()
        idCardNumberTF.placeholder = "idCardNumber_toast_message".localiz()
        salesRepresentativeLbl.text = "sales_representative".localiz()
        salesRepresentativeTF.placeholder = "sales_representative_toast_message".localiz()
        firstNameLbl.text = "firstName".localiz()
        firstNameTF.placeholder = "firstName_toast_message".localiz()
        lastNameLbl.text = "lastName".localiz()
        lastNameTF.placeholder = "lastName_toast_message".localiz()
        mobileNumberLbl.text = "mobileNumber".localiz()
        mobileNumberTF.placeholder = "mobileNumber_toast_message".localiz()
        emailLbl.text = "email".localiz()
        emailTF.placeholder = "email_toast_message".localiz()
        dateTitleLbl.text = "DOB".localiz()
        selectDateLbl.text = "DOB_toast_message".localiz()
        genderLbl.text = "gender".localiz()
        selectGenderLbl.text = "Select gender"
        anniversaryDateLbl.text = "date_of_Aniversary".localiz()
        selectAnniversarydateLbl.text = "date_of_aniversary_toast_message".localiz()
        updateBtn.setTitle("update".localiz(), for: .normal)
        generalInfoBtn.setTitle("general_info".localiz(), for: .normal)
        personalInfoBtn.setTitle("personal_info".localiz(), for: .normal)
        deleteAccountLbl.text = "Delete Account".localiz()
        logoutLbl.text = "Logout".localiz()
    }
    
    func deleteAccount(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SuccessMessage2") as? SuccessMessage2
        vc!.delegate = self
        vc!.message = "are_sure_delete_account".localiz()
        vc?.btnName = "Delete".localiz()
        vc?.vcTitle = "Delete Account".localiz()
        vc!.flags = "0"
        vc!.modalPresentationStyle = .overCurrentContext
        vc!.modalTransitionStyle = .crossDissolve
        self.present(vc!, animated: true, completion: nil)
        
//        let alert = UIAlertController(title: "", message: "are_sure_delete_account".localiz(), preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { UIAlertAction in
//
//    }))
//        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
//    self.present(alert, animated: true, completion: nil)

    }
    
}
