//
//  HYT_ClaimDetailsVM.swift
//  Hoya Thailand
//
//  Created by syed on 28/03/23.
//

import Foundation
import LanguageManager_iOS

class HYT_ClaimDetailsVM: SuccessMessageDelegate{
    func goToLoginPage(item: HYT_SuccessMessageVC) {
        self.VC?.navigationController?.popToRootViewController(animated: true)
    }
    
    weak var VC : HYT_ClaimDetailsVC?
    var promotionProductList = [LsrProductDetails]()
    var token = UserDefaults.standard.string(forKey: "TOKEN") ?? ""
    var requestAPIs = RestAPI_Requests()
    
    //    MARK: - invoice Number Validation API
    func invoiceNumberValidationApi(parameter: JSON){
        self.VC?.startLoading()
        requestAPIs.invoiceNumberValidation_API(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        print("invoice number validation response",result?.lstAttributesDetails?[0].attributeId ?? 0)
                        if result?.lstAttributesDetails?[0].attributeId == 0{
                            self.VC?.scanCodeStatus = 1
//                            if self.VC?.flags == "scanned"{
//                                self.VC?.productValidationApi(productId: self.VC?.promotionData?.programId ?? 0)
//                            }else{
//                                self.VC?.stopLoading()
//                            }
                            self.VC?.stopLoading()
//                            self.VC?.productValidationApi(productId: self.VC?.productCode ?? 0)
                            self.VC?.combineValidationApi()
                        }else{
//                            self.VC?.scanCodeStatus = -1
//                            self.VC?.view.makeToast("Invoice number already exist",duration: 2.0,position: .center)
//                            if self.VC?.flags == "scanned"{
//                                self.VC?.reStartScan()
//                            }else{
//                                self.VC?.stopLoading()
//                            }
                            
                            self.VC?.stopLoading()
                            self.VC?.hoyaValidationApi()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print("No data found")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("invoice number error",error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    //    MARK: - Product Validation API
    func productValidationApi(parameter: JSON){
        self.VC?.startLoading()
        requestAPIs.productNumberValidation_API(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    print("product validation response",result?.lstAttributesDetails?[0].attributeId ?? 0)
                    DispatchQueue.main.async {
                        if result?.lstAttributesDetails?[0].attributeId == 1{
                            self.VC?.stopLoading()
                            self.VC?.productCodeStatus = 1
//                            self.VC?.combineValidationApi()
//                            if self.VC?.flags == "scanned"{
//                                self.VC?.timmer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.VC?.goToUploadCode), userInfo: nil, repeats: false)
//                            }
//                            self.VC?.hoyaValidationApi()
                            self.VC?.invoiceNumberCheckApi(invoiceNumber: self.VC?.invoiceNumberTF.text ?? "")
                        }else{
                            self.VC?.productCodeStatus = -1
                            self.VC?.view.makeToast("Summitted Len Design is not available".localiz(),duration: 2.0,position: .center)
                            self.VC?.stopLoading()
//                            if self.VC?.flags == "scanned"{
//                                self.VC?.reStartScan()
//                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print("No data found")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("invoice number error",error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    //    MARK: - COMBINE INVOICE NUMBER AND PRODUCT VALIDATION API
    func combine_Inv_Pro_Validation(parameter: JSON){
        self.VC?.startLoading()
        requestAPIs.checkSalesReturnStatus_API(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    print(result?.lstAttributesDetails?[0].attributeId , "Combination api")
                    DispatchQueue.main.async {
                        if result?.lstAttributesDetails?[0].attributeId == 1{
//                            self.VC?.salesReturnStatus = 1
                            self.VC?.stopLoading()
//                            self.VC?.claimSubmission_Api()
                            self.VC?.view.makeToast("This combination already exist".localiz(),duration: 2.0,position: .center)
                            
                        }else if result?.lstAttributesDetails?[0].attributeId == -2{
                            self.VC?.view.makeToast("Invalid claim request".localiz(),duration: 2.0,position: .center)
                        }else{
//                            self.VC?.salesReturnStatus = -1
//                            self.VC?.view.makeToast("Invalid claim request",duration: 2.0,position: .center)
//                            self.VC?.reStartScan()
                            self.VC?.stopLoading()
                            self.VC?.hoyaValidationApi()
                            
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print("No data found")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("invoice number error",error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    //    MARK: - CLAIM SUBMISSION API
    func claimSubmissionApi(parameter: JSON){
        self.VC?.startLoading()
        requestAPIs.claimSubmission_API(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    print(result?.returnMessage ?? "", "Claim submission")
                    DispatchQueue.main.async {
                        if result?.returnMessage == "1"{
                            self.VC?.stopLoading()
                            let vc = self.VC?.storyboard?.instantiateViewController(withIdentifier: "HYT_SuccessMessageVC") as? HYT_SuccessMessageVC
                            vc?.modalTransitionStyle = .crossDissolve
                            vc?.modalPresentationStyle = .overFullScreen
                            vc?.delegate = self
                            vc?.successMessage = "Claim request has been submitted successfully".localiz()
                            self.VC?.present(vc!, animated: true)
                        }else{
                            self.VC?.stopLoading()
                            self.VC?.view.makeToast("Invalid claim request".localiz(),duration: 2.0,position: .center)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print("No data found")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("invoice number error",error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    func hoyaValidationApi(paramters: JSON){
        self.VC?.startLoading()
        let urlString = hoyaValidationApiUrl
        let url = URL(string: urlString)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
//            do{
                let str = String(decoding: data, as: UTF8.self) as String?
                 print(str ?? "", "- invoice and product status")
                DispatchQueue.main.async {
                    if str ?? "" == "false"{
                        self.VC?.productAndInvoiceValidation = "false"
                            self.VC?.stopLoading()
                        self.VC?.view.makeToast("Invalid claim request".localiz(), duration: 2.0, position: .center)
                    }else{
                        self.VC?.productAndInvoiceValidation = "true"
                            self.VC?.stopLoading()
                            self.VC?.claimSubmission_Api()
                    }
                }
//            }catch{
//                     DispatchQueue.main.async{
//                         self.VC?.stopLoading()
//                         print("Invalid claim request".localiz(),error.localizedDescription)
//                     }
//            }
        })
        task.resume()
    }
    
    
    func productListApi(parameter: JSON){
        self.promotionProductList.removeAll()
        self.VC?.startLoading()
        requestAPIs.getPromotionDetailsProductList(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.promotionProductList = result?.lsrProductDetails ?? []
                    DispatchQueue.main.async {
                        if result?.lsrProductDetails?.count != 0{
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.stopLoading()
                        }
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
                    print("My Redeemption error",error?.localizedDescription ?? "")
                }
            }
        }
    }
            
}
