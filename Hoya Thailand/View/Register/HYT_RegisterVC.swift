//
//  HYT_RegisterVC.swift
//  Hoya Thailand
//
//  Created by syed on 14/02/23.
//


import Toast_Swift
import UIKit

class HYT_RegisterVC: BaseViewController,RegisterOtpDelegate, DropdownDelegate, LanguageDropDownDelegate,DateSelectedDelegate,UITextFieldDelegate, SuccessMessageDelegate {
    
    func acceptDate(_ vc: HYT_DatePickerVC) {
        if vc.isComeFrom == "DOB"{
            selectDOBLbl.text = vc.selectedDate
            dob = vc.selectedDate
        }
    }
    
    func declineDate(_ vc: HYT_DatePickerVC) {}
    func goToLoginPage() {
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
    }
    
    func didtappedLanguageBtn(item: HYT_LanguageDropDownVC) {
        languageLbl.text = item.language
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
            self.storeNameTF.text = ""
            self.selectRoleLbl.text = "Select role"
            self.firstNameTF.text = ""
            self.lastNameTF.text = ""
            self.emailTF.text = ""
            self.mobileNumberTF.text = ""
            self.selectSalesRepresentativeLbl.text = "Select sales representative"
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
            self.storeNameTF.text = ""
            self.selectRoleLbl.text = "Select role"
            self.firstNameTF.text = ""
            self.lastNameTF.text = ""
            self.emailTF.text = ""
            self.mobileNumberTF.text = ""
            self.selectSalesRepresentativeLbl.text = "Select sales representative"
            self.setPasswordTF.text = ""
            self.selectDOBLbl.text = "Select DOB"
            self.selectGenderLbl.text = "Select gender"
            self.idCardNumberTF.text = ""
        }
        
    }
    
    @IBOutlet weak var dobView: UIView!
//    @IBOutlet weak var dobStar: UILabel!
    
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
    var storeUserNameExistancy = 0
    var idCardValidationStatus = 2
    var salesRep_Id = 0
    var dob:String = ""
    var validationMobileNo = 0
    var accountTypeId = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC  = self

        mobileNumberTF.delegate = self
        setPasswordTF.delegate  = self
        idCardNumberTF.delegate = self
        storeNameTF.isUserInteractionEnabled = false
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
            self.view.makeToast("Select Account Type", duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("Enter the store ID", duration: 2.0, position: .center)
        }else if storeNameTF.text?.count == 0 {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" {
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
            self.view.makeToast("Select Account Type", duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("Enter the store ID", duration: 2.0, position: .center)
        }else if storeNameTF.text?.count == 0 {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" {
            self.view.makeToast("Select the Role", duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("Enter the first name", duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("Enter the last name", duration: 2.0, position: .center)
        }
//        else if emailTF.text?.count == 0 {
//            self.view.makeToast("Enter email", duration: 2.0, position: .center)
//        }
        else if mobileNumberTF.text?.count == 0 {
            self.view.makeToast("Enter your mobile number", duration: 2.0, position: .center)
        }else if selectSalesRepresentativeLbl.text == "Select sales representative" {
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
            self.view.makeToast("Select Account Type", duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("Enter the store ID", duration: 2.0, position: .center)
        }else if storeNameTF.text?.count == 0 {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" {
            self.view.makeToast("Select the Role", duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("Enter the first name", duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("Enter the last name", duration: 2.0, position: .center)
        }
//        else if emailTF.text?.count == 0 {
//            self.view.makeToast("Enter email", duration: 2.0, position: .center)
//        }
        else if mobileNumberTF.text?.count == 0 {
            self.view.makeToast("Enter your mobile number", duration: 2.0, position: .center)
        }else if selectSalesRepresentativeLbl.text == "Select sales representative" {
            self.view.makeToast("Selet sales representative", duration: 2.0, position: .center)
        }else if setPasswordTF.text?.count == 0 {
            self.view.makeToast("set password", duration: 2.0, position: .center)
        }else if idCardNumberTF.text?.count == 0 {
            self.view.makeToast("Enter the ID card number", duration: 2.0, position: .center)
        }else if storeUserNameExistancy == 1 {
            self.view.makeToast("This store ID already exist", duration: 2.0, position: .center)
        }else if emailExistancy == 1 && self.emailTF.text!.count != 0  {
            self.view.makeToast("This Email already exist try another email", duration: 2.0, position: .center)
        }else if validationMobileNo == 0 {
            self.view.makeToast("Enter a valid mobile number", duration: 2.0, position: .center)
        }else if mobileNumberExistancy == 1 {
            self.view.makeToast("This mobile number already exist try another mobile number", duration: 2.0, position: .center)
        }else if idCardValidationStatus != 1 {
            self.view.makeToast("Enter a valid ID card number", duration: 2.0, position: .center)
        }else{
            
            if selectAccountType.text  == "Individual"{
               
                   let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_RegisterOtpVC") as? HYT_RegisterOtpVC
                   vc?.modalPresentationStyle = .overFullScreen
                   vc?.modalTransitionStyle = .crossDissolve
//                   vc?.registrationData = self
                   vc?.delegate = self
                   present(vc!, animated: true)
            }else{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_RegisterOtpVC") as? HYT_RegisterOtpVC
                vc?.modalPresentationStyle = .overFullScreen
                vc?.modalTransitionStyle = .crossDissolve
//                vc?.registrationData = self
                vc?.delegate = self
                present(vc!, animated: true)
            }
   
        }
    }
    @IBAction func firstNameEditingDidEnd(_ sender: Any) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("Select Account Type", duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("Enter the store ID", duration: 2.0, position: .center)
        }else if storeNameTF.text?.count == 0 {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" {
            self.view.makeToast("Select the Role", duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("Enter the first name", duration: 2.0, position: .center)
        }
    }
    @IBAction func lastNameEditingDidEnt(_ sender: Any) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("Select Account Type", duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("Enter the store ID", duration: 2.0, position: .center)
        }else if storeNameTF.text?.count == 0 {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" {
            self.view.makeToast("Select the Role", duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("Enter the first name", duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("Enter the last name", duration: 2.0, position: .center)
        }
    }
    
    @IBAction func didTappedStoreIdTF(_ sender: UITextField) {
        if storeIdTF.text?.count != 0{
            checkStoreIdExistancy()
        }else{
            self.storeNameTF.text = ""
            self.selectRoleLbl.text = "Select role"
            self.firstNameTF.text = ""
            self.lastNameTF.text = ""
            self.emailTF.text = ""
            self.mobileNumberTF.text = ""
            self.selectSalesRepresentativeLbl.text = ""
            self.setPasswordTF.text = ""
            self.selectDOBLbl.text = "Select DOB"
            self.selectGenderLbl.text = "Select gender"
            self.idCardNumberTF.text = ""
        }
    }
    
    @IBAction func didTappedMobileNumberTF(_ sender: UITextField) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("Select Account Type", duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("Enter the store ID", duration: 2.0, position: .center)
        }else if storeNameTF.text?.count == 0 {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" {
            self.view.makeToast("Select the Role", duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("Enter the first name", duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("Enter the last name", duration: 2.0, position: .center)
        }else if mobileNumberTF.text?.count == 0{
            validationMobileNo = 0
        }else  if mobileNumberTF.text?.count != 9{
            self.view.makeToast("Mobile number should be 9 digit", duration: 2.0, position: .center)
            validationMobileNo = 0
        }else if String(mobileNumberTF.text?.prefix(1) ?? "") == "9" || String(mobileNumberTF.text?.prefix(1) ?? "") == "8" || String(mobileNumberTF.text?.prefix(1) ?? "") == "7" || String(mobileNumberTF.text?.prefix(1) ?? "") == "6"{
            validationMobileNo = 1
            checkMobileNumberExistancy()
        }else{
            self.view.makeToast("Enter a valid mobile number", duration: 2.0, position: .center)
            validationMobileNo = 0
        }
        
       
    }
    
    @IBAction func setPasswordEditingDidEnd(_ sender: Any) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("Select Account Type", duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("Enter the store ID", duration: 2.0, position: .center)
        }else if storeNameTF.text?.count == 0 {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" {
            self.view.makeToast("Select the Role", duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("Enter the first name", duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("Enter the last name", duration: 2.0, position: .center)
        }
//        else if emailTF.text?.count == 0 {
//            self.view.makeToast("Enter email", duration: 2.0, position: .center)
//        }
        else if mobileNumberTF.text?.count == 0 {
            self.view.makeToast("Enter your mobile number", duration: 2.0, position: .center)
        }else if selectSalesRepresentativeLbl.text == "Select sales representative" {
            self.view.makeToast("Selet sales representative", duration: 2.0, position: .center)
        }else if setPasswordTF.text?.count == 0 {
            self.view.makeToast("set password", duration: 2.0, position: .center)
        }
    }
    
    
    @IBAction func didTappedEmailTF(_ sender: UITextField) {
        if emailTF.text?.count != 0{
            if (emailTF.text?.isValidEmail == true){
                checkEmailExistancy()
            }else{
                view.makeToast("Enter a valid email", duration: 2.0, position: .center)
            }
        }
    }
    
    @IBAction func didTappedIDNumberTF(_ sender: UITextField) {
        if selectAccountType.text == "Select account type" {
            self.view.makeToast("Select Account Type", duration: 2.0, position: .center)
        }else if storeIdTF.text?.count == 0 {
            self.view.makeToast("Enter the store ID", duration: 2.0, position: .center)
        }else if storeNameTF.text?.count == 0 {
            self.view.makeToast("", duration: 2.0, position: .center)
        }else if selectRoleLbl.text == "Select role" {
            self.view.makeToast("Select the Role", duration: 2.0, position: .center)
        }else if firstNameTF.text?.count == 0 {
            self.view.makeToast("Enter the first name", duration: 2.0, position: .center)
        }else if lastNameTF.text?.count == 0 {
            self.view.makeToast("Enter the last name", duration: 2.0, position: .center)
        }
//        else if emailTF.text?.count == 0 {
//            self.view.makeToast("Enter email", duration: 2.0, position: .center)
//        }
        else if mobileNumberTF.text?.count == 0 {
            self.view.makeToast("Enter your mobile number", duration: 2.0, position: .center)
        }else if selectSalesRepresentativeLbl.text == "Select sales representative" {
            self.view.makeToast("Selet sales representative", duration: 2.0, position: .center)
        }else if setPasswordTF.text?.count == 0 {
            self.view.makeToast("set password", duration: 2.0, position: .center)
        }else if idCardNumberTF.text?.count == 0 {
            self.view.makeToast("Enter the ID card number", duration: 2.0, position: .center)
        }else if storeUserNameExistancy == 1 {
            self.view.makeToast("This store ID already exist", duration: 2.0, position: .center)
        }else if emailExistancy == 1 && self.emailTF.text!.count != 0  {
            self.view.makeToast("This Email already exist try another email", duration: 2.0, position: .center)
        }else if validationMobileNo == 0 {
            self.view.makeToast("Enter a valid mobile number", duration: 2.0, position: .center)
        }else if mobileNumberExistancy == 1 {
            self.view.makeToast("This mobile number already exist try another mobile number", duration: 2.0, position: .center)
        }else{
            checkIdcardNumber()
        }
    }
    
    
    //   MARK: - CHECK ID CARD VALIDATION API
        func checkIdcardNumber(){
            let parameter : [String : Any] = [
                "ActorId": 91,
                "RoleIDs": idCardNumberTF.text ?? ""
            ]
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
        self.VM.checkStoreIdExistancyApi(parameter: parameter)
    }
    
    func checkStoreUserNameExistancy(){
        let parameter : [String : Any] = [

            "ActionType": 13,
            "Location":[
                "UserName": locationCode
            ]
                
        ]
        self.VM.checkStoreUserNameExistancy(parameter: parameter)
    }
    
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength : Int = 10
        if textField == mobileNumberTF{
            maxLength = 9
        }else if textField == setPasswordTF{
            maxLength = 6
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
        let parameter : [String : Any] =
        [
            "ActionType": 0,
            "ObjCustomerJson": [
                "UserId": salesRep_Id,
                "RegType": "\(selectAccountType.text ?? "")",
                "LocationCode": "",
                "LoyaltyId": "",
                "LocationId": locationCode,
                "LocationName": "Banglore",
                "CountryId": 17,
                "CustomerTypeID": 60,
                "FirstName": "\(firstNameTF.text ?? "")",
                "LastName": "\(lastNameTF.text ?? "")",
                "MobilePrefix": "+66",
                "Mobile": "\(mobileNumberTF.text ?? "")",
                "Mobile_Two": "",
                "Password": "\(setPasswordTF.text ?? "")",
                "DOB": "\(dob)",
                "Gender": "\(selectGenderLbl.text ?? "")",
                "IdentificationNo": "\(idCardNumberTF.text ?? "")",
                "RegistrationSource": 3,
                "Title": "",
                "Zip": "",
                "Email": "\(emailTF.text ?? "")",
                "LanguageID": selectedLanguageId,
                "DisplayImage": ""

            ]
        ]
        self.VM.registrationApi(parameter: parameter)
    }
    
    func storeOwnerRegisterApi(){
        let parameter : [String : Any] = [
            "ActionType": 0,
                "ObjCustomerJson": [
                    "UserId": salesRep_Id, // Sales Representative userid
                    "RegType": "\(selectAccountType.text ?? "")",
                    "LocationCode": "",
                    "LoyaltyId": "",  // LocationCode (if UserName check api is valid)
                    "LocationId": locationCode ,
                    "LocationName": "Banglore", // Store Name.....(SEND LOCATION NAME HERE)
                    "CountryId": 17,
                    "CustomerTypeID": 60,
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
                    "Title": "",
                    "Zip": "",
                    "Email": "\(emailTF.text ?? "")",
                    "LanguageID": selectedLanguageId,
                    "DisplayImage": ""

                ]
        ]
        self.VM.registrationApi(parameter: parameter)
    }
    
    
    func popMessage(){
        let message = "You have registered successfully"
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_SuccessMessageVC") as? HYT_SuccessMessageVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.successMessage = message
        vc?.delegate = self
        present(vc!, animated: true)
    }
    
    
    
}
