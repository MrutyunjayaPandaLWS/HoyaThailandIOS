//
//  HYT_DashboardVM.swift
//  Hoya Thailand
//
//  Created by syed on 25/02/23.
//

import Foundation
import UIKit
import SDWebImage


class HYT_DashboardVM{
    weak var VC: HYT_DashboardVC?
    var requestAPIs = RestAPI_Requests()
    var dashboardOffers = [LstPromotionJsonList]()
    
    func dashBoardApi(parameter: JSON){
        
        self.VC?.startLoading()
        self.requestAPIs.dashBoardApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    let dashboarMyVehicleDetails = result?.objImageGalleryList ?? ""
                    if dashboarMyVehicleDetails.count == 0{
                    }else{
                    }
                   let dashboardDetails = result?.objCustomerDashboardList ?? []
                    if dashboardDetails.count != 0 {
                        UserDefaults.standard.setValue(result?.objCustomerDashboardList?[0].memberSince, forKey: "MemberSince")
                                print(result?.objCustomerDashboardList?[0].memberSince ?? "", "Membersince")
                                print(result?.objCustomerDashboardList?[0].notificationCount ?? "", "NotificationCount")
                                print(result?.objCustomerDashboardList?[0].redeemablePointsBalance ?? "", "totalpoints")

                                self.VC?.pointsLbl.text = "\(result?.objCustomerDashboardList?[0].redeemablePointsBalance ?? 0)"

                                UserDefaults.standard.setValue(result?.objCustomerDashboardList?[0].redeemablePointsBalance ?? "", forKey: "TotalPoints")
                                UserDefaults.standard.synchronize()
                                   
                            }
                        let customerFeedbakcJSON = result?.lstCustomerFeedBackJsonApi ?? []
                        if customerFeedbakcJSON.count != 0 {
                            if result?.lstCustomerFeedBackJsonApi?[0].customerStatus ?? 0 != 1{
                                DispatchQueue.main.async{
                                }
                            }else{
                                let profileImg = String(result?.lstCustomerFeedBackJsonApi?[0].customerImage ?? "").dropFirst(2)
                                print("\(PROMO_IMG1)\(profileImg), ProfilImage")
                                
                                self.VC?.profileImage.sd_setImage(with: URL(string: "\(PROMO_IMG1)\(profileImg)"), placeholderImage: UIImage(named: "ic_default_img"))
                                UserDefaults.standard.setValue(result?.lstCustomerFeedBackJsonApi?[0].firstName, forKey: "FirstName")
                                self.VC?.profileNameLbl.text = "Hi, \(result?.lstCustomerFeedBackJsonApi?[0].firstName ?? "")"
                                self.VC?.membershipId.text = result?.lstCustomerFeedBackJsonApi?[0].loyaltyId ?? ""
                                
                                self.VC?.roleLbl.text = result?.lstCustomerFeedBackJsonApi?[0].customerType ?? ""
                                
                                UserDefaults.standard.setValue(result?.lstCustomerFeedBackJsonApi?[0].customerType, forKey: "CustomerType")
                                
                                UserDefaults.standard.setValue(result?.lstCustomerFeedBackJsonApi?[0].loyaltyId, forKey: "LoyaltyId")
                                
                                UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].merchantEmail ?? "", forKey: "MerchantEmail")
                                print(result?.lstCustomerFeedBackJsonApi?[0].verifiedStatus ?? "")

                                UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].verifiedStatus ?? "4", forKey: "verificationStatus")

                                UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].customerMobile ?? "", forKey: "Mobile")
                                UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].firstName ?? "", forKey: "FirstName")
                                UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].lastName ?? "", forKey: "LastName")
                                UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].customerEmail ?? "", forKey: "CustomerEmail")
                                UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].merchantId ?? "", forKey: "MerchantID")
                                UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].referralCode ?? "", forKey: "ReferralCode")
                                UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].customerId ?? "", forKey: "CustomerId")
                                
                                UserDefaults.standard.synchronize()
                            }
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
    

//    MARK: - DASHBOARD OFFERS SECTION API
    func dashbaordOffers(parameter: JSON){
        self.dashboardOffers.removeAll()
        self.VC?.startLoading()
        requestAPIs.dashboardOffers(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.dashboardOffers = result?.lstPromotionJsonList ?? []
                    DispatchQueue.main.async {
                        if result?.lstPromotionJsonList?.count != 0{
                            self.VC?.ImageSetups()
                            let gestureRecognizer = UITapGestureRecognizer(target: self.VC.self, action: #selector(self.VC!.didTap))
                            self.VC!.offersSlideShow.addGestureRecognizer(gestureRecognizer)
                            self.VC?.stopLoading()
                            
                        }else{
                            self.VC?.ImageSetups()
                            let gestureRecognizer = UITapGestureRecognizer(target: self.VC.self, action: #selector(self.VC!.didTap))
                            self.VC!.offersSlideShow.addGestureRecognizer(gestureRecognizer)
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
}
