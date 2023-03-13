//
//  HYT_LoginVM.swift
//  Hoya Thailand
//
//  Created by syed on 24/02/23.
//

import Foundation
import UIKit
import Toast_Swift
import LanguageManager_iOS


class HYT_LoginVM{
    weak var VC: HYT_LoginVC?
    var requestAPIs = RestAPI_Requests()
    var timer = Timer()
    
    
//    MARK: -  CHECK MOBILE NUMEBR EXISTANCY
    func verifyMobileNumberAPI(paramters: JSON){
        self.VC?.startLoading()
        let url = URL(string: checkUserExistencyURL)!
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
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "TOKEN") ?? "")", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do{
                let str = String(decoding: data, as: UTF8.self) as String?
                 print(str, "- Mobile Number Existancy")
                if str ?? "" != "1"{
                    DispatchQueue.main.async{
                        self.VC?.stopLoading()
                        self.VC?.mobileNumberExistancy = -1
                        self.VC?.view.makeToast("Mobile_number_is_doesn't_exists".localiz(), duration: 2.0, position: .center)
                    }
                }else{
                    DispatchQueue.main.async{
                        self.VC?.mobileNumberExistancy = 1
                        self.VC?.stopLoading()
                    }
                }
                 }catch{
                     DispatchQueue.main.async{
                         self.VC?.stopLoading()
                         print("mobile Number existancy Error",error.localizedDescription)
                     }
            }
        })
        task.resume()
    }
    
//    MARK: - LOGIN SUBMISSION
    func loginSubmissionApi(parameter: JSON){
        self.VC?.startLoading()
        requestAPIs.loginApi(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    if result?.userList?.count != 0{
                        DispatchQueue.main.async {
                            let data = result?.userList?[0]
                            if data?.result != 1{
                                if self.VC?.mobileNumberExistancy != 1{
                                    self.VC?.view.makeToast("Mobile_number_is_doesn't_exists".localiz(), duration: 2.0, position: .center)
                                    self.VC?.stopLoading()
                                }else{
                                    self.VC?.view.makeToast("Password_is_incorrect".localiz(), duration: 2.0, position: .center)
                                    self.VC?.stopLoading()
                                }
                            }else{
                                
                                self.VC?.stopLoading()
                                UserDefaults.standard.set(data?.customerTypeID, forKey: "customerTypeID")
                                UserDefaults.standard.set(data?.userName, forKey: "userName")
                                UserDefaults.standard.set(data?.userId, forKey: "userId")
                                UserDefaults.standard.set(data?.merchantName, forKey: "merchantName")
                                UserDefaults.standard.set(data?.merchantEmailID, forKey: "merchantEmailID")
                                UserDefaults.standard.set(data?.merchantMobileNo, forKey: "merchantMobileNo")
                                UserDefaults.standard.set(data?.mobile, forKey: "mobile")
                                UserDefaults.standard.set(data?.email, forKey: "email")
                                UserDefaults.standard.set(data?.custAccountNumber, forKey: "custAccountNumber")
                                UserDefaults.standard.set(data?.userImage, forKey: "userImage")
                                UserDefaults.standard.set(data?.locationName, forKey: "locationName")
                                UserDefaults.standard.set(true, forKey: "UserLoginStatus")
                                if #available(iOS 13.0, *) {
                                    let sceneDelegate = self.VC?.view.window!.windowScene!.delegate as! SceneDelegate
                                    sceneDelegate.setHomeAsRootViewController()
                                } else {
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.setHomeAsRootViewController()
                                }
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
    
    
    
//    MARK: - TOKEN GENERATE
    func tokendata(){
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
        }else{
            let parameters : Data = "username=\(username)&password=\(password)&grant_type=password".data(using: .utf8)!
            
            let url = URL(string: tokenURL)!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do {
                request.httpBody = parameters
            } catch let error {
                print(error.localizedDescription)
            }
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                do{
                    let parseddata = try JSONDecoder().decode(TokenModels.self, from: data)
                    print(parseddata.access_token ?? "")
                    UserDefaults.standard.setValue(parseddata.access_token ?? "", forKey: "TOKEN")
                }catch let parsingError {
                    print("Error", parsingError)
                }
            })
            task.resume()
        }
    }
}
