//
//  HYT_RegisterVM.swift
//  Hoya Thailand
//
//  Created by syed on 24/02/23.
//

import Foundation
import UIKit
import Toast_Swift
import LanguageManager_iOS


class HYT_RegisterVM{
    weak var VC: HYT_RegisterVC?
    var requestAPIs = RestAPI_Requests()

    
    func languageListApi(parameter: JSON){
        VC?.startLoading()
        requestAPIs.language_Api(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        
                        if result?.lstAttributesDetails?.count != 0 {
                            self.VC?.stopLoading()
                        }else{
                            DispatchQueue.main.async {
                                self.VC?.stopLoading()
                            }
                        }
                    }
                }else{
                    
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("Language Api error",error?.localizedDescription)
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                }
            }
        }
        
    }
    
    //    MARK: - CHECK MOBILE NUMBER EXISTANCY
    func checkMobileNumberExistancyApi(parameter : JSON){
        self.VC?.startLoading()
        requestAPIs.storeMobileNumberExistancy_Api(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    
                    if result?.returnValue == 1{
                        DispatchQueue.main.async {
                            self.VC?.view.makeToast("mobile_number_alreadyExits".localiz(), duration: 2.0, position: .center)
                            self.VC?.mobileNumberExistancy = 1
                            self.VC?.stopLoading()
                        } 
                    }else{
                        self.VC?.mobileNumberExistancy = 0
                        self.VC?.stopLoading()
                    }
                    
                }else{
                    DispatchQueue.main.async {
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
    
//    MARK: - CHECK STORE-ID EXISTANCY
    func checkStoreIdExistancyApi(parameter : JSON){
        self.VC?.startLoading()
        requestAPIs.checkStoreIdExistancy_Api(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    if result?.lstAttributesDetails?.count != 0 {
                        DispatchQueue.main.async {
                            if String(result?.lstAttributesDetails?[0].attributeValue?.prefix(2) ?? "") != "-2"{
                               // self.VC?.view.makeToast("This storeId allready exists", duration: 2.0, position: .center)
                                self.VC?.storeIdStatus = 1
                                self.VC?.locationCode = "\(result?.lstAttributesDetails?[0].attributeId ?? 0)"
                                self.VC?.storeId = "\(result?.lstAttributesDetails?[0].attributeId ?? 0)"
                                self.VC?.storeCode = "\(result?.lstAttributesDetails?[0].attributeNames ?? "")"
                                self.VC?.selectSalesRepresentativeLbl.text = "sales_representative_toast_message".localiz()
                                self.VC?.storeNameTF.text = result?.lstAttributesDetails?[0].attributeValue
                                self.VC?.storeNameTF.textColor = .black
                                self.VC?.checkStoreUserNameExistancy()
                                self.VC?.stopLoading()
                            }else{
                                self.VC?.storeNameTF.text = ""
                                self.VC?.view.makeToast("Invalid Store Id", duration: 2.0, position: .center)
                                self.VC?.selectSalesRepresentativeLbl.text = "sales_representative_toast_message".localiz()
                                self.VC?.storeIdStatus = 0
                                self.VC?.stopLoading()
                            }   
                        }
                    }else{
                        self.VC?.storeIdStatus = 0
                        self.VC?.stopLoading()
                    }

                }else{
                    DispatchQueue.main.async {
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
    
    
    func checkEmailExistancyApi(parameter : JSON){
        self.VC?.startLoading()
        requestAPIs.checkEmailExistancy_Api(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    
                    if result?.returnValue == 1{
                        DispatchQueue.main.async {
                            self.VC?.view.makeToast("This Email allready exists", duration: 2.0, position: .center)
                            self.VC?.emailExistancy = 1
                            self.VC?.stopLoading()
                        }
                    }else{
                        self.VC?.emailExistancy = 0
                        self.VC?.stopLoading()
                    }
                    
                }else{
                    DispatchQueue.main.async {
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
    
    func checkStoreUserNameExistancy(parameter : JSON){
        self.VC?.startLoading()
        requestAPIs.checkStoreUserNameExistancy(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    
                    if result?.returnValue == 1{
                        DispatchQueue.main.async {
                            if self.VC?.selectAccountType.text == "Individual"{
                                self.VC?.view.makeToast("This store User Name already registered", duration: 2.0, position: .center)
                            }
                            self.VC?.storeUserNameExistancy = 1
                            self.VC?.stopLoading()
                        }
                    }else{
                        if self.VC?.selectAccountType.text == "Store owner"{
                            self.VC?.view.makeToast("The store user name is not exist", duration: 2.0, position: .center)
                        }
                        self.VC?.storeUserNameExistancy = 0
                        self.VC?.stopLoading()
                    }
                    
                }else{
                    DispatchQueue.main.async {
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
    
    func checkIdcardValidation(parameter : JSON){
        self.VC?.startLoading()
        requestAPIs.checkIdcardNumberValidation(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    
                    if result?.lstAttributesDetails?[0].attributeId == 1{
                        DispatchQueue.main.async {
                            
                            self.VC?.idCardValidationStatus = 1
                            self.VC?.stopLoading()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.VC?.idCardValidationStatus = 2
                            self.VC?.view.makeToast("wrong_idCard_message".localiz(), duration: 2.0, position: .center)
                            self.VC?.stopLoading()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
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
    
    
    
    //    MARK: - REGISTRATION API
    func registrationApi(parameter: JSON){
            self.VC?.startLoading()
            requestAPIs.registrationApi(parameters: parameter) { result, error in
                if error == nil{
                    if result != nil{
                        DispatchQueue.main.async {
                            print(result?.returnMessage)
                            if String(result?.returnMessage?.prefix(1) ?? "") == "1"{
                                self.VC?.popMessage()
                                self.VC?.navigationController?.popViewController(animated: true)
                                self.VC?.stopLoading()
                            }else{
                                self.VC?.view.makeToast("registrationFailed".localiz(), duration: 2.0, position: .center)
                                self.VC?.stopLoading()
                            }
                            
                        }
                    }else{
                        DispatchQueue.main.async {
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
}

