//
//  HYT_RegisterVC.swift
//  Hoya Thailand
//
//  Created by syed on 14/02/23.
//


import Toast_Swift
import UIKit
import LanguageManager_iOS

class HYT_RegisterVC: BaseViewController,RegisterOtpDelegate, DropdownDelegate, LanguageDropDownDelegate,DateSelectedDelegate,UITextFieldDelegate, SuccessMessageDelegate,CheckBoxSelectDelegate {
    
    func accept(_ vc: HYT_TermAndConditionsVC) {
        termAndCondBtn.setImage(UIImage(named: "check-box"), for: .normal)
        termsAndCondStatus = 1
    }
    
    func decline(_ vc: HYT_TermAndConditionsVC) {
        termAndCondBtn.setImage(UIImage(named: "check-box-empty"), for: .normal)
        termsAndCondStatus = 0
    }
    
    func acceptDate(_ vc: HYT_DatePickerVC) {
        if vc.isComeFrom == "DOB"{
            selectDOBLbl.text = vc.selectedDate
            dob = vc.selectedDate
        }
    }
    
    func declineDate(_ vc: HYT_DatePickerVC) {}
    func goToLoginPage(item: HYT_SuccessMessageVC) {
        navigationController?.popViewController(animated: true)
    }
    
    func getRegistrationApi() {
        if selectAccountType.text == "Individual"{
            individualRegisterApi()
        }else{
            storeOwnerRegisterApi()
        }
    }
    

    func didTappedSalesRepresentative(item: HYT_DropDownVC) {
        salesRep_Id = item.salesRepId
        selectSalesRepresentativeLbl.text = item.salesRepresentativeName
        self.selectSalesRepresentativeLbl.textColor = .black
    }
    
    func didTappedRoleBtn(item: HYT_DropDownVC) {
        selectRoleLbl.text = item.roleName
        roleId = item.roleId
    }
    
    func didtappedLanguageBtn(item: HYT_LanguageDropDownVC) {
        localization()
    }
    
    func didTappedPromotionName(item: HYT_DropDownVC) {
        
    }
    
    func didTappedGenderBtn(item: HYT_DropDownVC) {
        selectGenderLbl.text = item.genderName
    }
    
    func didTappedAccountType(item: HYT_DropDownVC) {
        selectAccountType.text = item.accountType
        if item.accountType == "Individual"{
            roleView.isHidden = false
            roleTitleLbl.isHidden = false
            roleStarImage.isHidden = false
            firstNameTopConstraint.constant = 82
//            dobStar.isHidden = false
            dobTitleLbl.isHidden = false
            dobView.isHidden = false
           
            genderTitleLbl.isHidden = false
            genderView.isHidden = false
            genderTopView.constant = 154
            self.accountTypeId = 2
            self.storeIdTF.text = ""
            self.storeNameLbl1.text = "storeName_toast_message".localiz()
            self.storeNameLbl1.textColor = lightGraycolor1
            self.selectRoleLbl.text = "Select role"
            self.firstNameTF.text = ""
            self.lastNameTF.text = ""
            self.emailTF.text = ""
            self.mobileNumberTF.text = ""
            self.selectSalesRepresentativeLbl.text = "Select Sales Representative"
            self.setPasswordTF.text = ""
            self.selectDOBLbl.text = "Select DOB"
            self.selectGenderLbl.text = "Select gender"
            self.idCardNumberTF.text = ""
            
        }else{
            self.accountTypeId = 1
            roleView.isHidden = true
            roleTitleLbl.isHidden = true
            roleStarImage.isHidden = true
            firstNameTopConstraint.constant = 10
//            dobStar.isHidden = true
            dobTitleLbl.isHidden = true
            dobView.isHidden = true
            genderTitleLbl.isHidden = true
            genderView.isHidden = true
            genderTopView.constant = 10
            self.storeIdTF.text = ""
            self.storeNameLbl1.text = "storeName_toast_message".localiz()
            self.storeNameLbl1.textColor = lightGraycolor1
            self.selectRoleLbl.text = "Select role"
            self.firstNameTF.text = ""
            self.lastNameTF.text = ""
            self.emailTF.text = ""
            self.mobileNumberTF.text = ""
            self.selectSalesRepresentativeLbl.text = "Select Sales Representative"
            self.setPasswordTF.text = ""
            self.selectDOBLbl.text = "Select DOB"
            self.selectGenderLbl.text = "Select gender"
            self.idCardNumberTF.text = ""
        }
        
    }
    
    @IBOutlet weak var storeNameLbl1: UILabel!
    @IBOutlet weak var termAndCondLbl: UILabel!
    @IBOutlet weak var dobView: UIView!
//    @IBOutlet weak var dobStar: UILabel!
    
    @IBOutlet weak var termAndCondBtn: UIButton!
    @IBOutlet weak var genderTopView: NSLayoutConstraint!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var firstNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var roleView: UIView!
    @IBOutlet weak var roleStarImage: UILabel!
    @IBOutlet weak var selectGenderLbl: UILabel!
    @IBOutlet weak var genderTitleLbl: UILabel!
    @IBOutlet weak var selectDOBLbl: UILabel!
    @IBOutlet weak var dobTitleLbl: UILabel!
    @IBOutlet weak var selectRoleLbl: UILabel!
    @IBOutlet weak var roleTitleLbl: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var backToLoginLbl: UILabel!
    @IBOutlet weak var idCardNumberTF: UITextField!
    @IBOutlet weak var idCardNumberLbl: UILabel!
    @IBOutlet weak var setPasswordTF: UITextField!
    @IBOutlet weak var setPasswordLbl: UILabel!
    @IBOutlet weak var selectSalesRepresentativeLbl: UILabel!
    @IBOutlet weak var salesRepresentativeLbl: UILabel!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var storeNameTF: UITextField!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeIdTF: UITextField!
    @IBOutlet weak var storeIdLbl: UILabel!
    @IBOutlet weak var selectAccountType: UILabel!
    @IBOutlet weak var accountTypeLbl: UILabel!
    @IBOutlet weak var registerInfoLbl: UILabel!
    @IBOutlet weak var registerTitleLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    
    var storeIdStatus = 0
    var VM = HYT_RegisterVM()
    weak var VC1 : HYT_RegisterOtpVC?
    var mobileNumberExistancy = 1
    var emailExistancy = 0
    var storeIdExistancy = 1
    var locationCode: String = ""
    var storeCode: String = ""
    var storeId: String = ""
    var roleId: Int = 0
    var storeUserNameExistancy = 0
    var idCardValidationStatus = 2
    var salesRep_Id = 0
    var dob:String = ""
    var validationMobileNo = 0
    var accountTypeId = -1
    var termsAndCondStatus = 0
    var lightGraycolor1 = #colorLiteral(red: 0.1291644871, green: 0.1372229457, blue: 0.1414006352, alpha: 0.3758601511)
    var gender = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC  = self
        localization()
        mobileNumberTF.delegate = self
        setPasswordTF.delegate  = self
        idCardNumberTF.delegate = self
        storeNameTF.isUserInteractionEnabled = false
        termAndCondBtn.setImage(UIImage(named: "check-box-empty"), for: .normal)
        termsAndCondStatus = 0
        idCardNumberTF.keyboardType = .numberPad
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        languageLbl.text = selectedLanguage
        
    }
    
    @IBAction func didTappedSelectGenderBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DropDownVC") as? HYT_DropDownVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.flags = "gender"
        present(vc!, animated: true)
    }
    @IBAction func didTappedDOBBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DatePickerVC") as? HYT_DatePickerVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.isComeFrom = "DOB"
        present(vc!, animated: true)
    }
    @IBAction func didTappedSelectRoleBtn(_ sender: UIButton) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("selectAccountType".localiz(), duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("storeId_toast_message".localiz(), duration: 2.0, position: .center)
        }else if storeNameLbl1.text == "storeName_toast_message".localiz() {
            self.view.makeToast("storeName_toast_message".localiz(), duration: 2.0, position: .center)
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DropDownVC") as? HYT_DropDownVC
            vc?.modalTransitionStyle = .crossDissolve
            vc?.modalPresentationStyle = .overFullScreen
            vc?.delegate = self
            vc?.accountTypeId = self.accountTypeId
            vc?.flags = "role"
            present(vc!, animated: true)
        }
    }
    @IBAction func didTappedSelectLanguageBtn(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_LanguageDropDownVC") as? HYT_LanguageDropDownVC
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        vc?.delegate = self
        present(vc!, animated: true)
    }
    @IBAction func didTappedSelectAccountTypeBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DropDownVC") as? HYT_DropDownVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.flags = "accountType"
        present(vc!, animated: true)
    }
    
    
    @IBAction func didTappedSalesRepresentativeBtn(_ sender: UIButton) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("selectAccountType".localiz(), duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("storeId_toast_message".localiz(), duration: 2.0, position: .center)
        }else if storeNameLbl1.text == "storeName_toast_message".localiz() {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" && selectAccountType.text == "Individual"{
            self.view.makeToast("select_role".localiz(), duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("firstName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("lastName_toast_message".localiz(), duration: 2.0, position: .center)
        }
//        else if emailTF.text?.count == 0 {
//            self.view.makeToast("Enter email", duration: 2.0, position: .center)
//        }
        else if mobileNumberTF.text?.count == 0 {
            self.view.makeToast("mobileNumber_toast_message".localiz(), duration: 2.0, position: .center)
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DropDownVC") as? HYT_DropDownVC
            vc?.modalTransitionStyle = .crossDissolve
            vc?.modalPresentationStyle = .overFullScreen
            vc?.delegate = self
            vc?.locationId = locationCode
            vc?.flags = "sales"
            present(vc!, animated: true)
        }
    }
    
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTappedRegisterBtn(_ sender: UIButton) {
        
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("selectAccountType".localiz(), duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("storeId_toast_message".localiz(), duration: 2.0, position: .center)
        }else if storeNameLbl1.text == "storeName_toast_message".localiz() {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" && selectAccountType.text == "Individual"{
            self.view.makeToast("select_role".localiz(), duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("firstName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("lastName_toast_message".localiz(), duration: 2.0, position: .center)
        }
//        else if emailTF.text?.count == 0 {
//            self.view.makeToast("Enter email", duration: 2.0, position: .center)
//        }
        else if mobileNumberTF.text?.count == 0 {
            self.view.makeToast("mobileNumber_toast_message".localiz(), duration: 2.0, position: .center)
        }else if selectSalesRepresentativeLbl.text == "Select Sales Representative" {
            self.view.makeToast("sales_representative_toast_message".localiz(), duration: 2.0, position: .center)
        }else if setPasswordTF.text?.count == 0 {
            self.view.makeToast("password_toast_message".localiz(), duration: 2.0, position: .center)
        }else if idCardNumberTF.text?.count == 0 {
            self.view.makeToast("idCardNumber_toast_message".localiz(), duration: 2.0, position: .center)
        }
//        else if storeUserNameExistancy == 1 {
//            self.view.makeToast("This_store_ID_already_exist".localiz(), duration: 2.0, position: .center)
//        }
        else if storeUserNameExistancy == 1 && selectAccountType.text == "Store owner"{
            self.view.makeToast("This store user name already exist", duration: 2.0, position: .center)
        }else if storeUserNameExistancy == 0 && selectAccountType.text == "Individual"{
            self.view.makeToast("This store user name is not register", duration: 2.0, position: .center)
        } else if emailExistancy == 1 && self.emailTF.text!.count != 0  {
            self.view.makeToast("email_validation".localiz(), duration: 2.0, position: .center)
        }else if validationMobileNo == 0 {
            self.view.makeToast("mobileNumbervalidation".localiz(), duration: 2.0, position: .center)
        }else if mobileNumberExistancy == 1 {
            self.view.makeToast("mobile_number_alreadyExits".localiz(), duration: 2.0, position: .center)
        }else if idCardValidationStatus != 1 {
            self.view.makeToast("wrong_idCard_message".localiz(), duration: 2.0, position: .center)
        }else if termsAndCondStatus == 0{
            self.view.makeToast("Accept the term & condition",duration: 2.0,position: .center)
        }else{
            
            if selectAccountType.text  == "Individual"{
               
                   let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_RegisterOtpVC") as? HYT_RegisterOtpVC
                   vc?.modalPresentationStyle = .overFullScreen
                   vc?.modalTransitionStyle = .crossDissolve
//                   vc?.registrationData = self
                   vc?.mobileNumber = mobileNumberTF.text ?? ""
                   vc?.delegate = self
                   present(vc!, animated: true)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_RegisterOtpVC") as? HYT_RegisterOtpVC
                vc?.modalPresentationStyle = .overFullScreen
                vc?.modalTransitionStyle = .crossDissolve
//                vc?.registrationData = self
                vc?.mobileNumber = mobileNumberTF.text ?? ""
                vc?.delegate = self
                present(vc!, animated: true)
            }
   
        }
    }
    @IBAction func firstNameEditingDidEnd(_ sender: Any) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("selectAccountType".localiz(), duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("storeId_toast_message".localiz(), duration: 2.0, position: .center)
        }else if storeNameLbl1.text == "storeName_toast_message".localiz() {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" && selectAccountType.text == "Individual" {
            self.view.makeToast("select_role".localiz(), duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("firstName_toast_message".localiz(), duration: 2.0, position: .center)
        }
    }
    @IBAction func lastNameEditingDidEnt(_ sender: Any) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("selectAccountType".localiz(), duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("storeId_toast_message".localiz(), duration: 2.0, position: .center)
        }else if storeNameLbl1.text == "storeName_toast_message".localiz() {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" && selectAccountType.text == "Individual" {
            self.view.makeToast("select_role".localiz(), duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("firstName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("lastName_toast_message".localiz(), duration: 2.0, position: .center)
        }
    }
    
    @IBAction func didTappedStoreIdTF(_ sender: UITextField) {
        if storeIdTF.text?.count != 0{
            checkStoreIdExistancy()
        }else{
            self.storeNameLbl1.text = "storeName_toast_message".localiz()
            self.storeNameLbl1.textColor = lightGraycolor1
            self.selectRoleLbl.text = "Select role"
            self.firstNameTF.text = ""
            self.lastNameTF.text = ""
            self.emailTF.text = ""
            self.mobileNumberTF.text = ""
            self.selectSalesRepresentativeLbl.text = "Select Sales Representative"
            self.setPasswordTF.text = ""
            self.selectDOBLbl.text = "Select DOB"
            self.selectGenderLbl.text = "Select gender"
            self.idCardNumberTF.text = ""
        }
    }
    
    @IBAction func didTappedMobileNumberTF(_ sender: UITextField) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("selectAccountType".localiz(), duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("storeName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if storeNameLbl1.text == "storeName_toast_message".localiz() {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" && selectAccountType.text == "Individual"{
            self.view.makeToast("select_role".localiz(), duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("firstName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("lastName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if mobileNumberTF.text?.count == 0{
            validationMobileNo = 0
        }else  if mobileNumberTF.text?.count != 9{
            self.view.makeToast("mobileNumbervalidation".localiz(), duration: 2.0, position: .center)
            validationMobileNo = 0
            mobileNumberTF.text = ""
        }else if String(mobileNumberTF.text?.prefix(1) ?? "") == "9" || String(mobileNumberTF.text?.prefix(1) ?? "") == "8" || String(mobileNumberTF.text?.prefix(1) ?? "") == "7" || String(mobileNumberTF.text?.prefix(1) ?? "") == "6"{
            validationMobileNo = 1
            checkMobileNumberExistancy()
        }else{
            self.view.makeToast("mobileNumbervalidation".localiz(), duration: 2.0, position: .center)
            mobileNumberTF.text = ""
            validationMobileNo = 0
        }
        
       
    }
    
    @IBAction func setPasswordEditingDidEnd(_ sender: Any) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("selectAccountType".localiz(), duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("storeId_toast_message".localiz(), duration: 2.0, position: .center)
        }else if storeNameLbl1.text == "storeName_toast_message".localiz() {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" && selectAccountType.text == "Individual"{
            self.view.makeToast("select_role".localiz(), duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("firstName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("lastName_toast_message".localiz(), duration: 2.0, position: .center)
        }
//        else if emailTF.text?.count == 0 {
//            self.view.makeToast("Enter email", duration: 2.0, position: .center)
//        }
        else if mobileNumberTF.text?.count == 0 {
            self.view.makeToast("mobileNumber_toast_message".localiz(), duration: 2.0, position: .center)
        }else if selectSalesRepresentativeLbl.text == "Select Sales Representative"{
            self.view.makeToast("sales_representative_toast_message".localiz(), duration: 2.0, position: .center)
        }else if setPasswordTF.text?.count == 0 {
            self.view.makeToast("password_toast_message".localiz(), duration: 2.0, position: .center)
        }
    }
    
    
    @IBAction func didTappedEmailTF(_ sender: UITextField) {
        if emailTF.text?.count != 0{
            if (emailTF.text?.isValidEmail == true){
                checkEmailExistancy()
            }else{
                view.makeToast("wrong_email_format".localiz(), duration: 2.0, position: .center)
            }
        }
    }
    
    @IBAction func didTappedIDNumberTF(_ sender: UITextField) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("selectAccountType".localiz(), duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("storeId_toast_message".localiz(), duration: 2.0, position: .center)
        }else if storeNameLbl1.text == "storeName_toast_message".localiz() {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" && selectAccountType.text == "Individual"{
            self.view.makeToast("select_role".localiz(), duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("firstName_toast_message".localiz(), duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("lastName_toast_message".localiz(), duration: 2.0, position: .center)
        }
//        else if emailTF.text?.count == 0 {
//            self.view.makeToast("Enter email", duration: 2.0, position: .center)
//        }
        else if mobileNumberTF.text?.count == 0 {
            self.view.makeToast("mobileNumber_toast_message".localiz(), duration: 2.0, position: .center)
        }else if selectSalesRepresentativeLbl.text == "Select Sales Representative" {
            self.view.makeToast("sales_representative_toast_message".localiz(), duration: 2.0, position: .center)
        }else if setPasswordTF.text?.count == 0 {
            self.view.makeToast("password_toast_message".localiz(), duration: 2.0, position: .center)
        }else if idCardNumberTF.text?.count == 0 {
            self.view.makeToast("idCardNumber_toast_message".localiz(), duration: 2.0, position: .center)
        }else if storeUserNameExistancy == 1 && selectAccountType.text == "Store owner"{
            self.view.makeToast("This store user name already exist", duration: 2.0, position: .center)
        }else if storeUserNameExistancy == 0 && selectAccountType.text == "Individual"{
            self.view.makeToast("This store user name is not register", duration: 2.0, position: .center)
        }else if emailExistancy == 1 && self.emailTF.text!.count != 0  {
            self.view.makeToast("email_validation".localiz(), duration: 2.0, position: .center)
        }else if validationMobileNo == 0 {
            self.view.makeToast("mobileNumbervalidation".localiz(), duration: 2.0, position: .center)
        }else if mobileNumberExistancy == 1 {
            self.view.makeToast("mobile_number_alreadyExits".localiz(), duration: 2.0, position: .center)
        }else{
            checkIdcardNumber()
        }
    }
    
    
    @IBAction func selectTermAndConditionBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HYT_TermAndConditionsVC") as! HYT_TermAndConditionsVC
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    MARK: - Check ID card Existancy
    func checkIDcardExiistancy(){
        let parameter : [String : Any] = [
            "ActionType" : 198,
            "MobilePrefix": idCardNumberTF.text ?? ""
        ]
        print(parameter,"checkIDcardExiistancy")
        self.VM.checkIdcardExistancy(parameter: parameter)
    }
    
    
    //   MARK: - CHECK ID CARD VALIDATION API
        func checkIdcardNumber(){
            let parameter : [String : Any] = [
                "RoleIDs": idCardNumberTF.text ?? ""
            ]
            print(parameter,"checkIdcardNumber")
            self.VM.checkIdcardValidation(parameter: parameter)
        }
   
//   MARK: - CHECK EMAIL API
    func checkEmailExistancy(){
        let parameter : [String : Any] = [
                "ActionType": 14,
                "Location":[
                    "UserName":emailTF.text ?? ""
                ]
        ]
        self.VM.checkEmailExistancyApi(parameter: parameter)
    }
    
    //   MARK: - CHECK MOBILE NUMBER API
    func checkMobileNumberExistancy(){
        let parameter : [String : Any] = [
                "ActionType": 57,
                "Location":[
                    "UserName":mobileNumberTF.text ?? ""
                ]
        ]
        self.VM.checkMobileNumberExistancyApi(parameter: parameter)
    }
    
    //   MARK: - CHECK STORE-ID API
    func checkStoreIdExistancy(){
        let parameter : [String : Any] = [

                    "ActionType": 160,
                    "RoleIDs": storeIdTF.text ?? ""
                
        ]
        print(parameter,"checkStoreIdExistancy")
        self.VM.checkStoreIdExistancyApi(parameter: parameter)
    }
    
    func checkStoreUserNameExistancy(){
        let parameter : [String : Any] = [

            "ActionType": 13,
            "Location":[
                "UserName": storeCode
            ]
                
        ]
        print(parameter,"checkStoreUserNameExistancy")
        self.VM.checkStoreUserNameExistancy(parameter: parameter)
    }
    
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength : Int = 10
        if textField == mobileNumberTF{
            maxLength = 9
        }else if textField == setPasswordTF{
            maxLength = 15
        }else if textField == idCardNumberTF{
            maxLength = 13
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

}

extension HYT_RegisterVC{
    
    
    func individualRegisterApi(){
        if selectGenderLbl.text != "Select gender"{
            gender = selectGenderLbl.text ?? ""
        }
        
        let parameter : [String : Any] =
        [
            "ActionType": 0,
            "ObjCustomerJson": [
                "UserId": salesRep_Id,
                "RegType": "\(selectAccountType.text ?? "")",
                "LocationCode": storeCode,// store code
                "LoyaltyId": storeCode,// store code // atribute name
                "LocationId":  storeId,// store id
                "LocationName": storeNameLbl1.text ?? "",
                "CountryId": 84,
                "CustomerTypeID": roleId, // if store owner -54 else individual -
                "FirstName": "\(firstNameTF.text ?? "")",
                "LastName": "\(lastNameTF.text ?? "")",
                "MobilePrefix": "+66",
                "Mobile": "\(mobileNumberTF.text ?? "")",
                "Mobile_Two": "",
                "Password": "\(setPasswordTF.text ?? "")",
                "DOB": "\(dob)",
                "Gender": "\(gender)",
                "IdentificationNo": "\(idCardNumberTF.text ?? "")",
                "RegistrationSource": 3,
                "Title": "Mr.",
                "Zip": "",
                "Email": "\(emailTF.text ?? "")",
                "LanguageID": selectedLanguageId,
                "DisplayImage": ""

            ]
        ]
        print(parameter,"individual register")
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            self.VM.registrationApi(parameter: parameter)
        }
//        self.VM.registrationApi(parameter: parameter)
    }
    
    func storeOwnerRegisterApi(){
        if selectGenderLbl.text != "Select gender"{
            gender = selectGenderLbl.text ?? ""
        }
        let parameter : [String : Any] = [
            "ActionType": 0,
                "ObjCustomerJson": [
                    "UserId": salesRep_Id, // Sales Representative userid
                    "RegType": "\(selectAccountType.text ?? "")",
                    "LocationCode": storeCode,
                    "LoyaltyId": storeCode,  // LocationCode (if UserName check api is valid)
                    "LocationId": storeId,
                    "LocationName": storeNameLbl1.text ?? "", // Store Name.....(SEND LOCATION NAME HERE)
                    "CountryId": 84,
                    "CustomerTypeID": 54,
                    "FirstName": "\(firstNameTF.text ?? "")",
                    "LastName": "\(lastNameTF.text ?? "")",
                    "MobilePrefix": "+66",
                    "Mobile": "\(mobileNumberTF.text ?? "")",
                    "Mobile_Two": "",
                    "Password": "\(setPasswordTF.text ?? "")",
                    "DOB": "",
                    "Gender": "",
                    "IdentificationNo": "\(idCardNumberTF.text ?? "")",
                    "RegistrationSource": 3,
                    "Title": "Mr.",
                    "Zip": "",
                    "Email": "\(emailTF.text ?? "")",
                    "LanguageID": selectedLanguageId,
                    "DisplayImage": ""

                ]
        ]
        print(parameter,"Store owner registration")
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            self.VM.registrationApi(parameter: parameter)
        }
//        self.VM.registrationApi(parameter: parameter)
    }
    
    
    func popMessage(){
        let message = "register_success_Message".localiz()
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_SuccessMessageVC") as? HYT_SuccessMessageVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.successMessage = message
        vc?.delegate = self
        present(vc!, animated: true)
    }
    
    private func localization(){
        registerTitleLbl.text = "register".localiz()
        registerInfoLbl.text = "register_info".localiz()
        accountTypeLbl.text = "account_type".localiz()
        languageLbl.text = "language".localiz()
        storeIdLbl.text = "stoeId".localiz()
        storeIdTF.placeholder = "storeId_toast_message".localiz()
        storeNameLbl.text = "storeName".localiz()
        storeNameLbl1.text = "storeName_toast_message".localiz()
        storeNameLbl1.textColor = lightGraycolor1
        roleTitleLbl.text = "role".localiz()
        selectRoleLbl.text = "Select role"
        firstNameLbl.text = "firstName".localiz()
        firstNameTF.placeholder = "firstName_toast_message".localiz()
        lastNameTF.placeholder = "lastName_toast_message".localiz()
        lastNameLbl.text = "lastName".localiz()
        emailLbl.text = "email".localiz()
        emailTF.placeholder = "email_toast_message".localiz()
        mobileNumberTF.placeholder = "mobileNumber_toast_message".localiz()
        mobileNumberLbl.text = "mobileNumber".localiz()
        salesRepresentativeLbl.text = "sales_representative".localiz()
        selectSalesRepresentativeLbl.text = "Select Sales Representative"
        setPasswordLbl.text = "setPassword".localiz()
        setPasswordTF.placeholder = "password_toast_message".localiz()
        dobTitleLbl.text = "DOB".localiz()
        selectDOBLbl.text = "Select DOB"
        genderTitleLbl.text = "gender".localiz()
        selectGenderLbl.text = "Select gender"
        idCardNumberLbl.text = "idCardNumber".localiz()
        idCardNumberTF.placeholder = "idCardNumber_toast_message".localiz()
        backToLoginLbl.text = "back_Login".localiz()
        registerBtn.setTitle("register".localiz(), for: .normal)
        termAndCondLbl.text = "accept terms and condition".localiz()
    }
    
}
