//
//  HYT_VoucherListVM.swift
//  Hoya Thailand
//
//  Created by syed on 27/02/23.
//

import Foundation

class HYT_VoucherListVM{
    var requestAPIs = RestAPI_Requests()
    weak var VC: HYT_VoucherVC?
    var voucherListArray = [ObjCatalogueList1]()
    var pointExpireDetails = [eVoucherPointExpModel]()
    func voucherListApi(parameter: JSON){
//        self.voucherListArray.removeAll()
        self.VC?.startLoading()
        requestAPIs.getVoucherListApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        let voucherList = result?.objCatalogueList ?? []
                        if voucherList.count != 0 && voucherList.isEmpty == false {
                            self.voucherListArray += voucherList
                            self.VC?.noOfElement = self.voucherListArray.count
                            if self.voucherListArray.count != 0{
                                self.VC?.emptyMessageLbl.isHidden = true
                                self.VC?.voucherTableView.reloadData()
                                self.VC?.stopLoading()
                            }else{
                                self.VC?.emptyMessageLbl.isHidden = false
                                self.VC?.startIndex = 1
                                self.VC?.noOfElement = 0
                                self.VC?.voucherTableView.reloadData()
                                self.VC?.emptyMessageLbl.text = "No data found"
                                self.VC?.stopLoading()
                            }
                            
                        }else{
                            self.VC?.stopLoading()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.emptyMessageLbl.text = "No data found"
                        self.VC?.stopLoading()
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("My Redeemption error",error?.localizedDescription)
                }
            }
        }
    }
    
//    MARK: - VOUCHER EXPIRE DETAILS API
    func expirePointsDetailsApi(parameter: JSON){
        self.VC?.startLoading()
        requestAPIs.evoucherPointExpireApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.pointExpireDetails = result?.lstAttributesDetails ?? []
                    DispatchQueue.main.async {
                        if result?.lstAttributesDetails?.count != 0 {
                            self.VC?.pointsLbl.text = "\(result?.lstAttributesDetails?[0].attributeId ?? 0) Points"
                            self.VC?.expireDateLbl.text = "will Expire on : \(result?.lstAttributesDetails?[0].attributeNames ?? "")"
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
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("My VOUCHER EXPIRE error",error?.localizedDescription)
                }
            }
        }
    }

    
    //    MARK: - VOUCHER REDEEMPTION API
        func voucherRedeemptionApi(parameter: JSON){
            self.VC?.startLoading()
            requestAPIs.voucherRedeemption(parameters: parameter) { result, error in
                if error == nil{
                    if result != nil{
                        DispatchQueue.main.async {
                            self.VC?.successMessagePopUp(message: "Your voucher redeemed successfully")
                            print("exception message - ",result?.exceptionMessage)
                            print("exceptionType - ",result?.exceptionType)
                            print("message - ",result?.message)
                            print("stackTrace -",result?.stackTrace)
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
                        print("Voucher Redeemption error",error?.localizedDescription)
                    }
                }
            }
            DispatchQueue.main.async {
                self.VC?.stopLoading()
            }
        }

}
//voucherRedeemption
