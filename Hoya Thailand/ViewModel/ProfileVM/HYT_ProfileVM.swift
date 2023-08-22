//
//  HYT_ProfileVM.swift
//  Hoya Thailand
//
//  Created by syed on 28/02/23.
//

import Foundation
import Toast_Swift
import LanguageManager_iOS

class HYT_ProfileVM{
    
    weak var VC : HYT_MyProfileVC?
    var requestAPIs = RestAPI_Requests()
    var generalInfo = [LstCustomerJson]()
    func customerGeneralInfo(parameter: JSON){
        self.generalInfo.removeAll()
        self.VC?.startLoading()
        requestAPIs.getGeneralInfo(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.generalInfo = result?.lstCustomerJson ?? []
                    DispatchQueue.main.async {
                        if result?.lstCustomerJson?.count != 0{
                            self.VC?.membershipIDTF.text = self.generalInfo[0].loyaltyId ?? ""
                            self.VC?.roleTF.text = self.generalInfo[0].customerType ?? ""
                            self.VC?.storeIDTF.text = self.generalInfo[0].locationCode ?? ""
                            self.VC?.storeNameTF.text = self.generalInfo[0].locationName ?? "-"
                            self.VC?.salesRepresentativeTF.text = self.generalInfo[0].user ?? ""
                            self.VC?.firstNameTF.text = self.generalInfo[0].firstName ?? ""
                            self.VC?.lastNameTF.text = self.generalInfo[0].lastName ?? ""
                            self.VC?.mobileNumberTF.text = self.generalInfo[0].mobile ?? ""
                            self.VC?.emailTF.text = self.generalInfo[0].email ?? ""
                            if self.generalInfo[0].gender?.count == 0 || self.generalInfo[0].gender == nil{
                                self.VC?.selectGenderLbl.text = "Select gender"
                            }else{
                                self.VC?.selectGenderLbl.text = self.generalInfo[0].gender ?? "-"
                            }
                            let DOB = self.generalInfo[0].jdob?.split(separator: " ")
                            self.VC?.selectDateLbl.text = String(DOB?[0] ?? "Select DOB")
                            let DOA = self.generalInfo[0].anniversary?.split(separator: " ")
                            self.VC?.selectAnniversarydateLbl.text = String(DOA?[0] ?? "Select Date")
                            self.VC?.registerationNo = self.generalInfo[0].registrationSource ?? 0
                            self.VC?.idCardNumberTF.text = self.generalInfo[0].identificationNo ?? "-"
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.stopLoading()
                        }
//                        if result?.lstCustomerIdentityInfo?.count != 0{
//                            self.VC?.idCardNumberTF.text = result?.lstCustomerIdentityInfo?[0]
//                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("My profile error",error?.localizedDescription)
                }
            }
        }
    }
    
    
    
    func peofileUpdate(parameter: JSON){
        self.VC?.startLoading()
        requestAPIs.profileUpdate(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    if ((result?.returnMessage?.contains("1")) != nil){
                        self.VC?.successMessagePopUp(message: "profile_update_success_message".localiz())
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.view.makeToast("Profile isn't Update", duration: 2.0, position: .center)
                            self.VC?.stopLoading()
                        }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("My profile Update error",error?.localizedDescription)
                }
            }
        }
    }
    
    func deleteAccount(parameters: JSON, completion: @escaping (DeleteAccountModels?) -> ()) {
        self.VC?.startLoading()
        self.requestAPIs.deleteAccountApi(parameters: parameters) { (result, error) in
            if error == nil {
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                        self.VC?.stopLoading()
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                }
                
            }
            
        }
    }
}
