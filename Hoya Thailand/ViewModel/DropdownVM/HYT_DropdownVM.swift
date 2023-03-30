//
//  HYT_DropdownVM.swift
//  Hoya Thailand
//
//  Created by syed on 24/02/23.
//

import Foundation
import UIKit

class HYT_DropdownVM{
    
    var requestAPIs = RestAPI_Requests()
    weak var VC: HYT_DropDownVC?
    var roleListArray = [LstAttributesDetails2]()
    var salesRepresentativeList = [LstAttributesDetails3]()
    var queryStatusList = [LstAttributesDetails5]()
    var promotionList = [LtyPrgBaseDetails]()
    var promotionProductList = [LsrProductDetails]()
    
    func roleListinApi(parameter: JSON){
        self.roleListArray.removeAll()
        self.VC?.startLoading()
        requestAPIs.roleListing_API(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    
                    DispatchQueue.main.async {
                        for data in result?.lstAttributesDetails ?? []{
                            if data.attributeValue ?? "" != "Store Owner"{
                                self.roleListArray.append(data)
                            }
                        }
                                
                        if self.roleListArray.count != 0{
                            self.VC?.heightOfTableView.constant = CGFloat(45 * self.roleListArray.count)
                            self.VC?.rowNumber = self.roleListArray.count
                            
                            
                            self.VC?.dropdownTableView.reloadData()
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
                    print("roleListin error",error?.localizedDescription)
                }
            }
        }
    }
    
    
    func salesRepresentativeApi(parameter: JSON){
        self.salesRepresentativeList.removeAll()
        self.VC?.startLoading()
        requestAPIs.salesRepresentative_API(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.salesRepresentativeList = result?.lstAttributesDetails ?? []
                    DispatchQueue.main.async {
                        if result?.lstAttributesDetails?.count != 0{
                            self.VC?.heightOfTableView.constant = CGFloat(45*self.salesRepresentativeList.count)
                            self.VC?.rowNumber = self.salesRepresentativeList.count
                            self.VC?.dropdownTableView.reloadData()
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
                    print("salesRepresentativeAPi error",error?.localizedDescription)
                }
            }
        }
    }
    

    func queryStatusListing(parameter: JSON){
        self.queryStatusList.removeAll()
        self.VC?.startLoading()
        requestAPIs.queryStatusListApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.queryStatusList = result?.lstAttributesDetails ?? []
                    DispatchQueue.main.async {
                        if result?.lstAttributesDetails?.count != 0{
                            self.VC?.heightOfTableView.constant = CGFloat(45*self.queryStatusList.count)
                            self.VC?.rowNumber = self.queryStatusList.count
                            self.VC?.dropdownTableView.reloadData()
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
                    print("salesRepresentativeAPi error",error?.localizedDescription)
                }
            }
        }
    }
    

    
    func prommtionsListApi(parameter: JSON){
        self.promotionList.removeAll()
        self.VC?.startLoading()
        requestAPIs.getPromotionListApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.promotionList = result?.ltyPrgBaseDetails ?? []
                    DispatchQueue.main.async {
                        if result?.ltyPrgBaseDetails?.count != 0 && result?.ltyPrgBaseDetails != nil{
                            self.VC?.heightOfTableView.constant = CGFloat(45*self.promotionList.count)
                            self.VC?.rowNumber = self.promotionList.count
                            self.VC?.dropdownTableView.reloadData()
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.heightOfTableView.constant = CGFloat(45*self.promotionList.count)
                            self.VC?.heightOfTableView.constant = CGFloat(45*self.promotionList.count)
                            self.VC?.dropdownTableView.reloadData()
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
                    print("My Redeemption error",error?.localizedDescription)
                }
            }
        }
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
                            self.VC?.heightOfTableView.constant = CGFloat(45*self.promotionProductList.count)
                            self.VC?.rowNumber = self.promotionProductList.count
                            self.VC?.dropdownTableView.reloadData()
                            self.VC?.stopLoading()
                        }else{
                            self.VC?.heightOfTableView.constant = CGFloat(45*self.promotionProductList.count)
                            self.VC?.heightOfTableView.constant = CGFloat(45*self.promotionProductList.count)
                            self.VC?.dropdownTableView.reloadData()
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
                    print("My Redeemption error",error?.localizedDescription)
                }
            }
        }
    }
    
    
}
